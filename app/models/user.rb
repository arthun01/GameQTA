class User < ApplicationRecord
  has_secure_password
  has_many :user_sessions, dependent: :destroy
  has_many :theme_attempts, dependent: :destroy
  has_one :leaderboard, dependent: :destroy

  enum :education_level, {
    fundamental_incompleto: 0,
    fundamental_completo: 1,
    medio_incompleto: 2,
    medio_completo: 3,
    tecnico: 4,
    superior_incompleto: 5,
    superior_completo: 6
  }

  validates :full_name, :age, :city, :education_level, presence: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def block!
    transaction do
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
end
