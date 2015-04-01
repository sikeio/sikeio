class AddDataToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :data, :json,default: {}
  end
end
