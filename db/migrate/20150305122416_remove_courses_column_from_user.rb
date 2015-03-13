class RemoveCoursesColumnFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :courses, :integer
  end
end
