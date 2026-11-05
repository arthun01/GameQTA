class AddRankingCodeToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :ranking_code, :string, limit: 12
    execute "UPDATE users SET ranking_code = upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 12))"
    change_column_null :users, :ranking_code, false
    add_index :users, :ranking_code, unique: true
  end

  def down
    remove_column :users, :ranking_code
  end
end
