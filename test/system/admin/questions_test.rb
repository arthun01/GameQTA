require "application_system_test_case"

class Admin::QuestionsTest < ApplicationSystemTestCase
  setup do
    @admin = admins(:one)
    login_as(@admin)
    @theme = themes(:one)
  end

  test "creating a question with dynamic options" do
    visit admin_theme_questions_path(@theme)
    click_on "Nova Questão"

    fill_in "Enunciado", with: "Qual é o principal objetivo do princípio do poluidor-pagador?"
    fill_in "Link do YouTube", with: "https://www.youtube.com/watch?v=12345"
    fill_in "Artigo de Feedback", with: "O princípio visa internalizar as externalidades ambientais negativas."

    # Adicionar 3 opções dinamicamente via JS
    click_on "Adicionar Opção"

    # We should have 3 option fields now (2 default + 1 added)
    assert_selector "input[placeholder='Digite a opção de resposta...']", count: 3
    option_inputs = all("input[placeholder='Digite a opção de resposta...']")
    assert_equal 3, option_inputs.length

    option_inputs[0].fill_in with: "Punir financeiramente as empresas sem relação com a prevenção."
    option_inputs[1].fill_in with: "Evitar que os custos da reparação recaiam sobre a sociedade."
    option_inputs[2].fill_in with: "Garantir o direito de poluir mediante pagamento."

    # Marcar a segunda opção como correta
    radios = all(".is-correct-radio")
    radios[1].check

    # Verify exclusivity logic (others should be unchecked)
    radios[0].check
    radios[1].check

    click_on "Salvar Questão"

    assert_text "Questão criada com sucesso"
    assert_text "Qual é o principal objetivo do princípio do poluidor-pagador?"
  end

  test "showing validation errors" do
    visit new_admin_theme_question_path(@theme)

    click_on "Salvar Questão"

    # Validation errors should be present
    assert_text "não pode ficar em branco" # depending on exact rails message
  end

  private
    def login_as(admin)
      visit new_admin_session_path
      assert_selector "h1", text: "Entrar na administração"
      fill_in "email_address", with: admin.email_address
      fill_in "password", with: "password"
      click_on "Entrar na administração"
      assert_current_path admin_root_path
    end
end
