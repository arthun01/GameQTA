class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.text :statement, null: false
      t.string :youtube_link, null: false
      t.text :feedback_article, null: false
      t.integer :difficulty, null: false, default: 0
      t.references :theme, null: false, foreign_key: true

      t.timestamps
    end
  end
end
