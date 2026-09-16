class CreateQuestionSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :question_submissions do |t|
      t.references :theme_attempt, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :option, null: true, foreign_key: true
      t.boolean :is_correct, null: false, default: false
      t.datetime :revealed_at, null: false
      t.integer :time_taken

      t.timestamps
    end
    add_index :question_submissions, [ :theme_attempt_id, :question_id ], unique: true
  end
end
