class AddFreeColumnToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :free, :boolean, default: false
  end
end
