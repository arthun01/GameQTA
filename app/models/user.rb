class User < ApplicationRecord
  has_secure_password
  has_many :user_sessions, dependent: :destroy

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
end
