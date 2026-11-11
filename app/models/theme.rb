class Theme < ApplicationRecord
  belongs_to :level
  has_many :questions, dependent: :restrict_with_error
  has_many :theme_attempts, dependent: :destroy

  validates :name, :description, :icon, presence: true

  def self.report_statistics
    responses = QuestionSubmission.answered.joins(:theme_attempt).group("theme_attempts.theme_id")
    {
      attempts: ThemeAttempt.group(:theme_id).count,
      responses: responses.count,
      correct: responses.where(is_correct: true).count
    }
  end

  def completed_by?(user)
    attempt = theme_attempts.latest_for(user).first if user.present?
    attempt.present? && attempt.completed? && attempt.all_questions_answered?
  end
end
