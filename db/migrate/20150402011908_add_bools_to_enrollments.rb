class AddBoolsToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :activated, :bool, default: false
    add_column :enrollments, :has_sent_invitation_email, :bool, default: false
    add_column :enrollments, :paid, :bool, default: false
  end
end
