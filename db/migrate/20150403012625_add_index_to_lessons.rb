class AddIndexToLessons < ActiveRecord::Migration
  def change
    add_index :lessons, [:course_id, :name], unique: true
  end
end
