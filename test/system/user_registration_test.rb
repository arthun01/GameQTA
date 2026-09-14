require "application_system_test_case"

class UserRegistrationTest < ApplicationSystemTestCase
  test "simular o preenchimento de todos os campos no formulário de /cadastrar e submeter" do
    visit "/cadastrar"

    assert_selector "h1", text: "Junte-se à aventura!"

    fill_in "Nome Completo", with: "João da Silva"
    fill_in "Idade", with: 15
    fill_in "Cidade", with: "São Paulo"
    select "Ensino Médio Incompleto", from: "Nível de Ensino"

    fill_in "E-mail", with: "joao.silva@example.com"
    fill_in "Senha", with: "senha123456"

    click_on "Começar a jogar!"

    assert_current_path "/jornada"
  end
end
