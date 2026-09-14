require "application_system_test_case"

class UserLoginTest < ApplicationSystemTestCase
  setup do
    @user = users(:student_one)
  end

  test "simular acesso em /entrar com as credenciais criadas e verificar o cookie/auth válido" do
    visit "/entrar"

    assert_selector "h1", text: "Bem-vindo de volta!"

    fill_in "E-mail", with: @user.email_address
    fill_in "Senha", with: "password" # fixtures devem ter senha 'password' ou similar

    click_on "Entrar para jogar"

    assert_current_path "/jornada"
  end
end
