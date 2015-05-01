class AddDiscoursePostIdToCheckin < ActiveRecord::Migration
  def change
    add_column :checkins, :discourse_post_id, :integer
  end
end
