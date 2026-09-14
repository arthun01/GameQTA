require "application_system_test_case"

class Admin::LevelsSystemTest < ApplicationSystemTestCase
  setup do
    @admin = admins(:one)
    # Login manually
    visit new_admin_session_path
    fill_in "email_address", with: @admin.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_text "Gerencie os grandes capítulos do jogo" # wait for dashboard to load
  end

  test "creating a Level" do
    visit admin_levels_url

    click_on "Novo Nível"

    assert_text "Novo Nível" # wait for the page to load

    fill_in "level[name]", with: "Nível Avançado"
    fill_in "level[description]", with: "Uma nova fase muito legal"
    fill_in "level[icon]", with: "🚀"

    click_on "Salvar"

    assert_text "Nível criado com sucesso."
    assert_text "Nível Avançado"
    assert_text "Uma nova fase muito legal"
    assert_text "🚀"
  end

  test "updating a Level" do
    visit admin_levels_url

    # Click edit on the first level in the list
    within(first(".group")) do
      click_on "Editar"
    end

    assert_text "Editar Nível" # wait for the page to load

    fill_in "level[name]", with: "Nível Atualizado E2E"
    click_on "Salvar"

    assert_text "Nível atualizado com sucesso."
    assert_text "Nível Atualizado E2E"
  end

  test "destroying a Level" do
    empty_level = Level.create!(name: "Nível Vazio", description: "Sem temas", icon: "🌱")
    visit admin_levels_url

    within(find(".group", text: empty_level.name)) do
      accept_confirm do
        click_on "Excluir"
      end
    end

    assert_text "Nível removido com sucesso."
  end
end
