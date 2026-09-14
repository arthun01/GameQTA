require "application_system_test_case"

class Admin::ThemesSystemTest < ApplicationSystemTestCase
  setup do
    @admin = admins(:one)
    @level = levels(:one)
    # create at least one theme for the level
    @theme = Theme.create!(name: "Tema Inicial", description: "Desc Inicial", icon: "📖", level: @level)

    # Login manually
    visit new_admin_session_path
    fill_in "email_address", with: @admin.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_text "Gerencie os grandes capítulos do jogo" # wait for dashboard to load
  end

  test "admin navigates from Level to Themes and sees the list" do
    visit admin_levels_url

    # Encontra o card do nível "Princípios do Direito Ambiental"
    # and click on "Ver temas"
    within(find(".group", text: @level.name)) do
      click_on "Ver temas"
    end

    assert_text "Temas"
    assert_text "Gerencie os temas deste nível"
    assert_text @level.name # breadcrumb
    assert_text @theme.name
  end

  test "creating a Theme" do
    visit admin_level_themes_url(@level)

    click_on "Novo Tema"
    assert_text "Novo Tema"

    fill_in "theme[name]", with: "Tema Avançado"
    fill_in "theme[description]", with: "Desc muito legal"
    fill_in "theme[icon]", with: "🚀"

    click_on "Salvar"

    assert_text "Tema criado com sucesso."
    assert_text "Tema Avançado"
    assert_text "Desc muito legal"
    assert_text "🚀"
  end

  test "updating a Theme" do
    visit admin_level_themes_url(@level)

    first("a", text: "Editar").click
    assert_text "Editar Tema"

    fill_in "theme[name]", with: "Tema Atualizado E2E"
    click_on "Salvar"

    assert_text "Tema atualizado com sucesso."
    assert_text "Tema Atualizado E2E"
  end

  test "destroying a Theme" do
    visit admin_level_themes_url(@level)

    accept_confirm do
      first("button", text: "Excluir").click
    end

    assert_text "Tema removido com sucesso."
  end
end
