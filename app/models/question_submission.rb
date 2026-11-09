class QuestionSubmission < ApplicationRecord
  belongs_to :theme_attempt
  belongs_to :question
  belongs_to :option, optional: true

  validates :revealed_at, presence: true
  validates :question_id, uniqueness: { scope: :theme_attempt_id }

  after_commit :update_leaderboard, on: %i[ create update destroy ]

  def allowed_seconds
    time_limit_seconds || GameSetting.current.time_for_difficulty(question.difficulty)
  end

  def remaining_seconds
    [ (deadline_at - Time.current).ceil, 0 ].max
  end

  def deadline_at
    revealed_at + allowed_seconds
  end

  def answer(option_id:)
    with_lock do
      if answered_at.nil? && self.option_id.nil?
        elapsed = [ Time.current - revealed_at, 0 ].max
        selected = question.options.find_by(id: option_id)
        selected = nil if elapsed > allowed_seconds + 2
        correct = selected&.is_correct? || false
        earned_score = correct ? points_for_question : 0
        update!(
          option: selected,
          is_correct: correct,
          score: earned_score,
          answered_at: Time.current,
          time_taken: elapsed.round
        )
      else
        false
      end
    end
  end

  private
    def points_for_question
      case question.difficulty
      when "easy" then 10
      when "medium" then 20
      when "hard" then 30
      else 0
      end
    end

    def update_leaderboard
      if User.exists?(theme_attempt.user_id)
        Leaderboards::UpdateUserJob.perform_later(theme_attempt.user_id)
      end
    end
end
