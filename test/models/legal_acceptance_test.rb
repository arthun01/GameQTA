require "test_helper"

class LegalAcceptanceTest < ActiveSupport::TestCase
  test "repeated acceptance of the same revision preserves the original timestamp" do
    user = users(:student_one)
    acceptance = user.legal_acceptances.sole

    travel 1.day do
      assert_no_difference "LegalAcceptance.count" do
        assert user.accept_legal_documents(accepted: "1", revision: LegalDocument.revision)
      end
      assert_equal acceptance.accepted_at, user.reload.accepted_terms_at
    end
  end

  test "a new document revision requires new acceptance and preserves the previous text" do
    user = users(:student_one)
    old_acceptance = user.legal_acceptances.sole
    old_snapshot = old_acceptance.document_snapshot.deep_dup
    original_documents = I18n.t(:legal_documents).deep_dup
    new_version = "0.3 — teste"
    I18n.backend.store_translations(I18n.default_locale, legal_documents: { shared: { version: new_version } })

    assert_not user.current_legal_acceptance?
    assert_not user.accept_legal_documents(accepted: "1", revision: old_acceptance.document_revision)
    assert_difference "LegalAcceptance.count", 1 do
      assert user.accept_legal_documents(accepted: "1", revision: LegalDocument.revision)
    end
    assert user.current_legal_acceptance?
    assert_equal old_snapshot, old_acceptance.reload.document_snapshot
    assert_equal new_version, user.legal_acceptances.find_by!(document_revision: LegalDocument.revision).terms_version
  ensure
    I18n.backend.store_translations(I18n.default_locale, legal_documents: original_documents) if original_documents
  end
end
