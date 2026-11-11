require "application_system_test_case"

class BranchConsolidationSystemTest < ApplicationSystemTestCase
  test "gameplay avatar opens the full profile outside the question frame" do
    visit entrar_path
    fill_in "E-mail", with: users(:student_one).email_address
    fill_in "Senha", with: "password"
    click_on "Entrar para jogar"
    assert_selector "h1", text: I18n.t("dashboard.index.title")
    find("summary", text: levels(:one).name).click
    click_button "Iniciar Tema", match: :first
    assert_selector "turbo-frame#question_play_area"

    avatar = find("a[aria-label='#{I18n.t('accessibility.profile_link')}']")
    assert_equal "_top", avatar["data-turbo-frame"]
    avatar.click
    assert_current_path profile_path
    assert_no_selector "turbo-frame#question_play_area"
    assert_text users(:student_one).email_address
  end
end
