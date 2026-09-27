require "application_system_test_case"

class RankingTest < ApplicationSystemTestCase
  setup do
    @user = users(:student_one)
  end

  test "visiting the ranking page" do
    visit "/entrar"
    fill_in "E-mail", with: @user.email_address
    fill_in "Senha", with: "password"
    click_on "Entrar para jogar"

    assert_current_path "/jornada"
    visit ranking_path

    assert_text "Ranking Global"
    assert_text "João"
  end
end
