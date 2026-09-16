require "application_system_test_case"

class GameplayTest < ApplicationSystemTestCase
  setup do
    @student = users(:student_one)

    visit entrar_path
    fill_in "E-mail", with: @student.email_address
    fill_in "Senha", with: "password"
    click_button "Entrar para jogar"
    assert_selector "h1", text: "Sua Jornada"
  end

  test "student can start theme, watch video and reveal question with working timer" do
    unlocked_level = Level.order(:id).first
    # We must ensure this level has a theme and a valid question
    theme = unlocked_level.themes.first
    unless theme.questions.any?
      q = theme.questions.build(statement: "Test Q", difficulty: :easy, youtube_link: "https://www.youtube.com/watch?v=123", feedback_article: "test")
      q.options.build(content: "A", is_correct: true)
      q.options.build(content: "B", is_correct: false)
      q.save!
    end

    visit jornada_path

    # Deve listar o Nível Liberado
    assert_selector "h2", text: unlocked_level.name

    # Clica no botão de jogar o primeiro tema
    click_on "Iniciar Tema", match: :first

    # Verifica que estamos na tela de consumo
    assert_selector "iframe" # Vídeo
    assert_selector "button", text: "Mostrar Questão"

    # Clica para revelar a questão
    click_on "Mostrar Questão"

    # Verifica que a turbo stream injetou o layout
    assert_text theme.questions.first.statement

    # Verifica o cronômetro
    assert_selector "[data-gameplay-timer-target='display']", text: "01:00" # default easy time is 60

    # Espera 1 segundo para ver o cronômetro mudar (sleep é ruim, mas no system test é aceitável para UI JS update rápido)
    sleep 1.1

    assert_selector "[data-gameplay-timer-target='display']", text: "00:59"
  end
end
