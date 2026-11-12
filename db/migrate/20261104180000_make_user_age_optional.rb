class MakeUserAgeOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :age, true
  end
end
