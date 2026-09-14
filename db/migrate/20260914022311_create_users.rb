class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :full_name, null: false
      t.integer :age, null: false
      t.string :city, null: false
      t.integer :education_level, null: false

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
