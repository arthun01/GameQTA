require "application_system_test_case"
class DebugTest < ApplicationSystemTestCase
  test "debug console" do
    @student = users(:student_one)
    visit entrar_path
    fill_in "E-mail", with: @student.email_address
    fill_in "Senha", with: "password"
    click_button "Entrar para jogar"

    visit jornada_path
    first("summary").click
    click_on "Iniciar Tema", match: :first
    click_on "Mostrar Questão"

    sleep 1

    logs = page.driver.browser.logs.get(:browser)
    puts "BROWSER LOGS: #{logs.map(&:message).join("\n")}"
  end
end
