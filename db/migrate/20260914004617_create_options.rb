class CreateOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :options do |t|
      t.string :content, null: false
      t.boolean :is_correct, null: false, default: false
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
