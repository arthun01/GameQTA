class CreateThemeAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :theme_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :theme_attempts, [ :user_id, :theme_id ], unique: true, where: "status = 0"
  end
end
