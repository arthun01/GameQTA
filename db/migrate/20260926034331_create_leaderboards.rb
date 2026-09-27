class CreateLeaderboards < ActiveRecord::Migration[8.1]
  def change
    create_table :leaderboards do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :total_score, null: false, default: 0
      t.integer :total_time_taken, null: false, default: 0

      t.timestamps
    end

    add_index :leaderboards, [ :total_score, :total_time_taken ], order: { total_score: :desc, total_time_taken: :asc }
  end
end
