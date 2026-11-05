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
end
