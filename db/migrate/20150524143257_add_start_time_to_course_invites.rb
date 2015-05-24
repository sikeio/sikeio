class AddStartTimeToCourseInvites < ActiveRecord::Migration
  def change
    add_column :course_invites, :start_time, :datetime
  end
end
