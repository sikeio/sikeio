class AddPermalinkIndexToLessons < ActiveRecord::Migration
  def change
    add_index :lessons, [:course_id , :permalink], unique: true
  end
end
