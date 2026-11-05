require "application_system_test_case"

class LegalAcceptanceSystemTest < ApplicationSystemTestCase
  test "legacy student can read documents without losing the acceptance form and then continue" do
    user = users(:student_one)
    user.legal_acceptances.destroy_all
    visit entrar_path
    fill_in "E-mail", with: user.email_address
    fill_in "Senha", with: "password"
    click_on "Entrar para jogar"

    assert_current_path new_legal_acceptance_path
    assert_selector "input[name='user[legal_documents_accepted]']:not([checked])"
    document_window = window_opened_by do
      within("form[action='#{legal_acceptance_path}']") { click_link "Termos de Uso" }
    end
    within_window document_window do
      assert_selector "h1", text: "Termos de Uso"
      assert_text LegalDocument.version
    end
    document_window.close
    assert_current_path new_legal_acceptance_path

    check "Li e concordo com os Termos de Uso"
    click_on "Registrar aceite e continuar"

    assert_current_path jornada_path
    assert user.reload.current_legal_acceptance?
    assert user.accepted_terms_at.present?
  end
end
