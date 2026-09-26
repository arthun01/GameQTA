class Leaderboards::UpdateUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    total_time = QuestionSubmission.joins(:theme_attempt)
                                   .where(theme_attempts: { user_id: user_id })
                                   .sum(:time_taken)

    total_score = QuestionSubmission.joins(:theme_attempt, :question)
                                    .where(theme_attempts: { user_id: user_id })
                                    .where(is_correct: true)
                                    .sum(
                                      "CASE questions.difficulty " \
                                      "WHEN 0 THEN 10 " \
                                      "WHEN 1 THEN 20 " \
                                      "WHEN 2 THEN 30 " \
                                      "ELSE 0 END"
                                    )

    Leaderboard.upsert(
      { user_id: user_id, total_score: total_score, total_time_taken: total_time },
      unique_by: :user_id
    )
  end
end
