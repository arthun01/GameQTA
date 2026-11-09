class Level < ApplicationRecord
  has_many :themes, dependent: :restrict_with_error

  validates :name, presence: true
  validates :description, presence: true

  def starting_level?
    self == Level.order(:id).first
  end

  def previous_level
    Level.where("id < ?", id).order(id: :desc).first
  end

  def last_theme?(theme)
    themes.order(:id).last == theme
  end

  def all_themes_completed_by?(user)
    return false if user.nil? || themes.empty?

    themes.all? { |theme| theme.completed_by?(user) }
  end

  def completed_by?(user)
    all_themes_completed_by?(user) && score_for(user) >= 70.0
  end

  def unlocked_for?(user)
    if starting_level?
      true
    else
      previous = previous_level
      previous.present? && previous.unlocked_for?(user) && previous.completed_by?(user)
    end
  end

  def score_for(user)
    return 0.0 if user.nil?

    total_questions = Question.where(theme_id: themes.select(:id)).count
    return 0.0 if total_questions.zero?

    latest_attempt_ids = themes.map do |theme|
      theme.theme_attempts.completed.where(user: user).order(created_at: :desc).first&.id ||
        theme.theme_attempts.where(user: user).order(created_at: :desc).first&.id
    end.compact

    submissions = QuestionSubmission.where(theme_attempt_id: latest_attempt_ids)
    correct = submissions.where(is_correct: true).count
    ((correct.to_f / total_questions) * 100).round(1)
  end

  def reset_progress_for!(user)
    ThemeAttempt.transaction do
      ThemeAttempt.where(user: user, theme: themes).destroy_all
    end
    if user.present?
      user.update_leaderboard
      Leaderboards::UpdateUserJob.perform_later(user.id)
    end
  end
end
