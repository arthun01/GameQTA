class Theme < ApplicationRecord
  belongs_to :level
  has_many :questions, dependent: :restrict_with_error
  has_many :theme_attempts, dependent: :destroy

  validates :name, :description, :icon, presence: true

  def completed_by?(user)
    return false if user.nil? || questions.empty?

    attempt = theme_attempts.completed.where(user: user).order(created_at: :desc).first
    if attempt.present?
      attempt.next_pending_question.nil?
    else
      false
    end
  end
end
