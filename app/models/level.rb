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

  def available_to?(user)
    Level.where("id < ?", id).order(:id).all? { |level| level.passed_by?(user) }
  end

  def completed_for?(user)
    attempts = latest_attempts_for(user).index_by(&:theme_id)
    themes.exists? && themes.all? do |theme|
      attempt = attempts[theme.id]
      attempt.present? && attempt.completed? && attempt.all_questions_answered?
    end
  end

  def passed_by?(user)
    total = required_questions.count
    completed_for?(user) && total.positive? && correct_answers_for(user) * 100 >= total * 70
  end

  def score_for(user)
    total = required_questions.count
    return 0.0 if total.zero?

    (correct_answers_for(user).to_f / total * 100).round(1)
  end

  def reset_progress_for(user)
    user.with_lock do
      ThemeAttempt.where(user: user, theme: themes).destroy_all
    end
  end

  private
    def latest_attempts_for(user)
      ThemeAttempt.where(user: user, theme_id: themes.select(:id))
        .order(created_at: :desc, id: :desc).to_a.uniq(&:theme_id)
    end

    def required_questions
      Question.where(theme_id: themes.select(:id))
    end

    def correct_answers_for(user)
      QuestionSubmission.answered.where(theme_attempt_id: latest_attempts_for(user).map(&:id),
        question_id: required_questions.select(:id), is_correct: true).distinct.count(:question_id)
    end
end
