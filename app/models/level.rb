class Level < ApplicationRecord
  has_many :themes, dependent: :restrict_with_error

  validates :name, presence: true
  validates :description, presence: true

  def starting_level?
    self == Level.order(:id).first
  end

  def last_theme?(theme)
    themes.order(:id).last == theme
  end

  def score_for(user)
    latest_attempt_ids = themes.map do |theme|
      theme.theme_attempts.where(user: user).order(created_at: :desc).first&.id
    end.compact

    submissions = QuestionSubmission.where(theme_attempt_id: latest_attempt_ids)

    total = submissions.count
    return 0.0 if total.zero?

    correct = submissions.where(is_correct: true).count
    ((correct.to_f / total) * 100).round(1)
  end

  def reset_progress_for!(user)
    ThemeAttempt.transaction do
      ThemeAttempt.where(user: user, theme: themes).destroy_all
    end
  end
end
