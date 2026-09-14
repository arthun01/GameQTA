class CreateLevels < ActiveRecord::Migration[8.1]
  def change
    create_table :levels do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :icon

      t.timestamps
    end
  end
end
