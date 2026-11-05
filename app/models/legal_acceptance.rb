class LegalAcceptance < ApplicationRecord
  belongs_to :user, touch: true

  validates :accepted_at, :document_revision, :terms_version, :privacy_version, :document_snapshot, presence: true
  validates :document_revision, uniqueness: { scope: :user_id }
  attr_readonly :user_id, :accepted_at, :document_revision, :terms_version, :privacy_version, :document_snapshot
end
