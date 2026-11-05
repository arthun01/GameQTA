require "application_system_test_case"

class StudentProfileSystemTest < ApplicationSystemTestCase
  test "student corrects their data and explicitly erases their own account" do
    visit entrar_path
    fill_in "E-mail", with: users(:student_one).email_address
    fill_in "Senha", with: "password"
    click_on "Entrar para jogar"

    click_link "Meu perfil e meus dados"
    click_link "Editar meus dados"
    fill_in "Cidade", with: "Ilhéus"
    fill_in "Senha atual", with: "password"
    click_on "Salvar alterações"

    assert_text "Seus dados foram atualizados."
    assert_selector "dd", text: "Ilhéus"
    fill_in "Senha atual", with: "password"
    check "Entendo as consequências", allow_label_click: true
    click_on "Excluir minha conta e meus dados"

    assert_current_path entrar_path
    assert_text "Sua conta e seus dados da aplicação ativa foram excluídos."
    assert_not User.exists?(users(:student_one).id)
  end
end
