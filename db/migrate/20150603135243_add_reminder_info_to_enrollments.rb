class AddReminderInfoToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :last_visit_time, :datetime
    add_column :enrollments, :invitation_sent_time, :datetime
    add_column :enrollments, :reminder_scheduled_at, :datetime
    add_column :enrollments, :reminder_state, :string
    add_column :enrollments, :reminder_count, :integer, :default => 0
    add_column :enrollments, :reminder_disabled, :boolean, :default => false
    add_column :enrollments, :number_of_lessons_from_current, :integer, :default => 0
  end
end
