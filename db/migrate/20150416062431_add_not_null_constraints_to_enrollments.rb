class AddNotNullConstraintsToEnrollments < ActiveRecord::Migration
  def down
  end
  def up
    change_column :enrollments, :user_id, :integer, :null => false
    change_column :enrollments, :course_id, :integer, :null => false
    change_column :enrollments, :token, :string, :null => false
  end
end
