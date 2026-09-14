class CreateThemes < ActiveRecord::Migration[8.1]
  def change
    create_table :themes do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.references :level, null: false, foreign_key: true

      t.timestamps
    end
  end
end
