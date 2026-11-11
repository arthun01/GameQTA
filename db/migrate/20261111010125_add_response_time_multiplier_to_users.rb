class AddResponseTimeMultiplierToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :response_time_multiplier, :integer, default: 1, null: false
  end
end
