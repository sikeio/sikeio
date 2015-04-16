class DropEnrollmentsDefaultTimes < ActiveRecord::Migration
  def up
    change_column_default :enrollments, :start_time, nil
    change_column_default :enrollments, :enroll_time, nil
    change_column :enrollments, :start_time, :datetime, null: true
    change_column :enrollments, :enroll_time, :datetime, null: true
  end
end
