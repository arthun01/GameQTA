class CreateGameSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :game_settings do |t|
      t.integer :easy_time, null: false, default: 60
      t.integer :medium_time, null: false, default: 45
      t.integer :hard_time, null: false, default: 30

      t.timestamps
    end
  end
end
