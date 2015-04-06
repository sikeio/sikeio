class AddIndexToCourses < ActiveRecord::Migration
  def change
    add_index :courses, :permalink, unique: true
  end
end
