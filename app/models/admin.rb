class Admin < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true, length: { maximum: 254 }
  validates :password, :password_confirmation, presence: true, on: :password_reset

  after_update :revoke_sessions, if: :saved_change_to_password_digest?
  before_destroy :ensure_remaining_admin, prepend: true

  def self.with_team_lock
    transaction do
      connection.execute("SELECT pg_advisory_xact_lock(20820, 1)")
      yield
    end
  end

  def save_for_team(attributes = {})
    assign_attributes(attributes)
    self.class.transaction(requires_new: true) { save }
  rescue ActiveRecord::RecordNotUnique
    errors.add(:email_address, :taken)
    false
  end

  def remove_from_team(actor:)
    self.class.with_team_lock do
      if actor.id == id
        errors.add(:base, :cannot_remove_self)
        false
      elsif !self.class.exists?(id: actor.id)
        errors.add(:base, :actor_unavailable)
        false
      else
        destroy
      end
    end
  end

  private
    def revoke_sessions
      sessions.destroy_all
    end

    def ensure_remaining_admin
      self.class.with_team_lock do
        if self.class.count <= 1
          errors.add(:base, :last_admin)
          throw :abort
        end
      end
    end
end
