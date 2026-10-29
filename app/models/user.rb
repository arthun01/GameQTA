class User < ApplicationRecord
  attr_accessor :current_password, :deletion_confirmed, :legal_revision
  attr_reader :legal_documents_accepted

  has_secure_password
  has_many :user_sessions, dependent: :destroy
  has_many :theme_attempts, dependent: :destroy
  has_one :leaderboard, dependent: :destroy
  has_many :legal_acceptances, dependent: :destroy

  enum :education_level, {
    fundamental_incompleto: 0,
    fundamental_completo: 1,
    medio_incompleto: 2,
    medio_completo: 3,
    tecnico: 4,
    superior_incompleto: 5,
    superior_completo: 6
  }, validate: { allow_nil: true }

  validates :full_name, :age, :email_address, presence: true
  validates :full_name, length: { maximum: 100 }
  validates :city, length: { maximum: 100 }, allow_nil: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 120 }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true, length: { maximum: 254 }
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :full_name, with: ->(value) { value.strip }
  normalizes :city, with: ->(value) { value.strip.presence }

  validate :validate_legal_acceptance, on: :registration
  before_create :set_initial_acceptance_time
  after_create :record_initial_legal_acceptance

  def legal_documents_accepted=(value)
    @legal_documents_accepted = ActiveModel::Type::Boolean.new.cast(value)
  end

  def current_legal_acceptance?
    legal_acceptances.exists?(document_revision: LegalDocument.revision)
  end

  def accept_legal_documents(accepted:, revision:)
    self.legal_documents_accepted = accepted
    self.legal_revision = revision
    errors.clear
    validate_legal_acceptance
    return false if errors.any?

    with_lock do
      acceptance = record_legal_acceptance
      update!(accepted_terms_at: acceptance.accepted_at)
    end
  end

  def update_profile(attributes, password:)
    with_lock do
      errors.clear
      if authenticate_profile_password(password)
        update(attributes)
      else
        false
      end
    end
  end

  def erase_account(password:, confirmed:)
    with_lock do
      errors.clear
      authenticate_profile_password(password)
      unless ActiveModel::Type::Boolean.new.cast(confirmed) == true
        errors.add(:deletion_confirmed, :accepted)
      end

      if errors.empty?
        destroy!
      else
        false
      end
    end
  end

  def update_leaderboard
    with_lock do
      unless blocked?
        submissions = QuestionSubmission.joins(:theme_attempt).where(theme_attempts: { user_id: id })
        total_time = submissions.sum(:time_taken)
        total_score = submissions.joins(:question).where(is_correct: true).sum(
          "CASE questions.difficulty WHEN 0 THEN 10 WHEN 1 THEN 20 WHEN 2 THEN 30 ELSE 0 END"
        )

        Leaderboard.upsert(
          { user_id: id, total_score: total_score, total_time_taken: total_time },
          unique_by: :user_id
        )
      end
    end
  end

  def block!
    with_lock do
      touch(:blocked_at)
      user_sessions.destroy_all
      leaderboard&.destroy
    end
  end

  def unblock!
    update(blocked_at: nil)
  end

  def blocked?
    blocked_at.present?
  end

  private
    def validate_legal_acceptance
      unless legal_documents_accepted == true
        errors.add(:legal_documents_accepted, :accepted)
      end
      unless legal_revision == LegalDocument.revision
        errors.add(:legal_revision, :stale)
      end
    end

    def set_initial_acceptance_time
      if legal_documents_accepted == true && legal_revision == LegalDocument.revision
        self.accepted_terms_at = Time.current
      end
    end

    def record_initial_legal_acceptance
      record_legal_acceptance(accepted_at: accepted_terms_at) if accepted_terms_at.present?
    end

    def record_legal_acceptance(accepted_at: Time.current)
      legal_acceptances.find_or_create_by!(document_revision: LegalDocument.revision) do |acceptance|
        acceptance.accepted_at = accepted_at
        acceptance.terms_version = LegalDocument.version
        acceptance.privacy_version = LegalDocument.version
        acceptance.document_snapshot = LegalDocument.snapshot
      end
    end

    def authenticate_profile_password(password)
      if password.present? && authenticate(password)
        true
      else
        errors.add(:current_password, :invalid)
        false
      end
    end
end
