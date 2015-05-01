class AddDiscourseTopicIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :discourse_topic_id, :integer
  end
end
