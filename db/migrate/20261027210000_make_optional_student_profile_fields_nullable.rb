class MakeOptionalStudentProfileFieldsNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :city, true
    change_column_null :users, :education_level, true
  end
end
