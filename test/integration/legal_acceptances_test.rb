require "test_helper"

class LegalAcceptancesTest < ActionDispatch::IntegrationTest
  test "registration rejects missing acceptance or an outdated document revision" do
    [ {}, { legal_documents_accepted: "0", legal_revision: LegalDocument.revision }, { legal_documents_accepted: "1", legal_revision: "old" } ].each do |acceptance|
      assert_no_difference [ "User.count", "LegalAcceptance.count", "UserSession.count" ] do
        post cadastrar_path, params: { user: registration_attributes.merge(acceptance) }
      end
      assert_response :unprocessable_entity
      assert_select "input[name='user[legal_documents_accepted]']:not([checked])"
      assert_no_match(/translation missing/i, response.body)
    end
  end

  test "registration stores the actual documents and server time and permits optional fields to be omitted" do
    travel_to Time.zone.local(2026, 10, 27, 15, 0, 0) do
      assert_difference [ "User.count", "LegalAcceptance.count", "UserSession.count" ], 1 do
        post cadastrar_path, params: { user: registration_attributes.merge(
          legal_documents_accepted: "1", legal_revision: LegalDocument.revision,
          accepted_terms_at: "2000-01-01", terms_version: "forged", blocked_at: Time.current
        ) }
      end

      assert_redirected_to jornada_path
      user = User.find_by!(email_address: "new-student@example.com")
      acceptance = user.legal_acceptances.sole
      assert_equal Time.current, user.accepted_terms_at
      assert_equal Time.current, acceptance.accepted_at
      assert_equal LegalDocument.snapshot, acceptance.document_snapshot
      assert_equal LegalDocument.version, acceptance.terms_version
      assert_equal LegalDocument.version, acceptance.privacy_version
      assert user.current_legal_acceptance?
      assert_nil user.blocked_at
      assert_nil user.city
      assert_nil user.education_level
    end
  end

  test "legacy accounts retain access to their rights while game actions require a current acceptance" do
    user = users(:student_one)
    user.legal_acceptances.destroy_all
    sign_in_as_user user
    assert_nil user.reload.accepted_terms_at

    [ jornada_path, ranking_path ].each do |path|
      get path
      assert_redirected_to new_legal_acceptance_path
    end
    assert_no_difference "ThemeAttempt.count" do
      post start_play_theme_path(themes(:one))
    end
    assert_redirected_to new_legal_acceptance_path

    [ profile_path, edit_profile_path, terms_path, privacy_policy_path, new_legal_acceptance_path ].each do |path|
      get path
      assert_response :success
    end
    assert_nil user.reload.accepted_terms_at

    assert_no_difference "LegalAcceptance.count" do
      post legal_acceptance_path, params: { user: { legal_documents_accepted: "0", legal_revision: LegalDocument.revision } }
    end
    assert_response :unprocessable_entity

    assert_difference "LegalAcceptance.count", 1 do
      post legal_acceptance_path, params: { user: { legal_documents_accepted: "1", legal_revision: LegalDocument.revision } }
    end
    assert_redirected_to jornada_path
    assert user.reload.accepted_terms_at.present?
    get jornada_path
    assert_response :success
  end

  test "an acceptance cannot be recorded without a student login" do
    assert_no_difference "LegalAcceptance.count" do
      post legal_acceptance_path, params: { user: { legal_documents_accepted: "1", legal_revision: LegalDocument.revision } }
    end
    assert_redirected_to entrar_path
  end

  private
    def registration_attributes
      { full_name: "Nova estudante", email_address: "new-student@example.com", password: "password123", age: 22 }
    end
end
