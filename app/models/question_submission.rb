class QuestionSubmission < ApplicationRecord
  belongs_to :theme_attempt
  belongs_to :question
  belongs_to :option, optional: true

  validates :revealed_at, presence: true
  validates :question_id, uniqueness: { scope: :theme_attempt_id }

  scope :answered, -> { where.not(answered_at: nil).or(where.not(option_id: nil)) }

  before_destroy :remember_leaderboard_user
  after_commit :update_leaderboard, on: [ :create, :update, :destroy ]

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
        update!(option: selected, is_correct: correct, score: correct ? points_for_question : 0,
          answered_at: Time.current, time_taken: elapsed.round)
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

    def remember_leaderboard_user
      @leaderboard_user_id = theme_attempt.user_id
    end

    def update_leaderboard
      Leaderboards::UpdateUserJob.perform_later(@leaderboard_user_id || theme_attempt.user_id)
    end
end
