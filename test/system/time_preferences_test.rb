require "application_system_test_case"

class TimePreferencesSystemTest < ApplicationSystemTestCase
  test "player saves a time preference from the profile and can restore the default" do
    visit entrar_path
    fill_in "E-mail", with: users(:student_one).email_address
    fill_in "Senha", with: "password"
    click_on "Entrar para jogar"
    assert_current_path jornada_path
    visit profile_path
    assert_no_selector "#response-time-preference[open]"
    find("#response-time-preference summary").click
    select "2× o tempo padrão", from: "Tempo para responder"
    save_screenshot("/tmp/gameqta-simplified-profile-desktop.png")
    click_on "Salvar tempo de resposta"
    assert_text "Tempo de resposta salvo para as próximas questões."
    assert_equal 2, users(:student_one).reload.response_time_multiplier

    page.current_window.resize_to(390, 844)
    find("#response-time-preference summary").click
    assert_operator page.evaluate_script("document.documentElement.scrollWidth"), :<=, page.evaluate_script("window.innerWidth")
    save_screenshot("/tmp/gameqta-simplified-profile-mobile.png")
    select "Tempo padrão (1×)", from: "Tempo para responder"
    click_on "Salvar tempo de resposta"
    assert_text "Tempo de resposta salvo"
    assert_equal 1, users(:student_one).reload.response_time_multiplier

    visit play_theme_attempt_question_path(theme_attempts(:one))
    assert_button "Assistir vídeo"
    assert_button "Mostrar Questão"
    assert_no_selector "select, iframe"
    save_screenshot("/tmp/gameqta-simplified-question-mobile.png")
    click_on "Mostrar Questão"
    assert_selector "fieldset"
    assert_no_selector "iframe"
  ensure
    page.current_window.resize_to(1400, 1400)
  end
end
