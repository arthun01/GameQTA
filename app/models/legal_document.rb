class LegalDocument
  def self.snapshot
    documents = I18n.t(:legal_documents, locale: I18n.default_locale).deep_stringify_keys
    {
      "shared" => documents.fetch("shared").slice("version", "updated_on", "draft_title", "draft_notice"),
      "terms" => documents.fetch("terms"),
      "privacy" => documents.fetch("privacy")
    }
  end

  def self.revision
    Digest::SHA256.hexdigest(JSON.generate(snapshot))
  end

  def self.version
    snapshot.fetch("shared").fetch("version")
  end
end
