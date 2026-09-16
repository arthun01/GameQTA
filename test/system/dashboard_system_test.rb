require "application_system_test_case"

class DashboardSystemTest < ApplicationSystemTestCase
  setup do
    @student = users(:student_one)

    # Autenticar manualmente via form de login
    visit entrar_path
    fill_in "E-mail", with: @student.email_address
    fill_in "Senha", with: "password"
    click_button "Entrar para jogar"
    assert_selector "h1", text: "Sua Jornada"
  end

  test "visiting the dashboard as a student" do
    visit jornada_path

    # Título da página
    assert_selector "h1", text: "Sua Jornada"
    assert_selector "p", text: "Explore o mapa do Game QTA e conquiste os níveis."

    # Verifica se os níveis aparecem.
    # O Level :one (Princípios do Direito Ambiental) deve estar visível
    assert_text levels(:one).name
    assert_text levels(:two).name

    # O level unlocked deve ter o botão Iniciar Tema
    assert_selector "form.button_to"
    assert_text "Iniciar Tema"
  end
end
