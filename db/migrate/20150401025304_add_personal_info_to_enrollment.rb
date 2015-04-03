class AddPersonalInfoToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :personal_info, :json, default: {}
  end
end
