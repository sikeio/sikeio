class AddBuddyNameToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :buddy_name, :string
  end
end
