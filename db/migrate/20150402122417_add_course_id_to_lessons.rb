class AddCourseIdToLessons < ActiveRecord::Migration
  def change
    add_reference :lessons, :course, index: true
  end
end
