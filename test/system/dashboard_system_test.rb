require "application_system_test_case"

class DashboardSystemTest < ApplicationSystemTestCase
  setup do
    @user = users(:student_one)
    @starting_level = Level.order(:id).first
    @locked_level = Level.order(:id).last
    # O theme listado no bloqueado será qualquer theme dele
    @theme = @locked_level.themes.first
  end

  test "visiting the dashboard as a student" do
    visit root_path

    # Deve redirecionar para login
    assert_current_path "/entrar"

    fill_in "E-mail", with: @user.email_address
    fill_in "Senha", with: "password"
    click_button "Entrar para jogar"

    assert_current_path "/jornada"

    assert_text "Sua Jornada"

    # Nível 1 deve estar liberado (com o botão Jogar)
    within(".space-y-6") do
      assert_text @starting_level.name
      assert_text "Jogar"
    end

    # Nível 2 deve estar bloqueado
    assert_text @locked_level.name

    # Clica no Nível 2 bloqueado
    find("button", text: @locked_level.name).click

    # O modal deve aparecer com o tema
    assert_text @locked_level.name
    assert_text "Alcance 70% de acertos no nível anterior para liberar."
    assert_text(/O que vem por aí/i)
    assert_text @theme.name if @theme
  end
end
