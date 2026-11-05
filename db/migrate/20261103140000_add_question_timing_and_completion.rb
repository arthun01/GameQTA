class AddQuestionTimingAndCompletion < ActiveRecord::Migration[8.1]
  def up
    add_column :question_submissions, :time_limit_seconds, :integer
    add_column :question_submissions, :answered_at, :datetime
    execute "UPDATE question_submissions SET answered_at = updated_at WHERE option_id IS NOT NULL OR is_correct = TRUE"
  end

  def down
    remove_column :question_submissions, :answered_at
    remove_column :question_submissions, :time_limit_seconds
  end
end
