class QuestionSubmission < ApplicationRecord
  belongs_to :theme_attempt
  belongs_to :question
  belongs_to :option, optional: true

  validates :revealed_at, presence: true
  validates :question_id, uniqueness: { scope: :theme_attempt_id }

  after_commit :update_leaderboard, on: [ :create, :update ]

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
        update!(option: selected, is_correct: selected&.is_correct? || false,
          answered_at: Time.current, time_taken: elapsed.round)
      else
        false
      end
    end
  end

  private

  def update_leaderboard
    Leaderboards::UpdateUserJob.perform_later(theme_attempt.user_id)
  end
end
