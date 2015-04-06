class AddTitleAndPermalinkToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :title, :string
    add_column :courses, :permalink, :string
  end
end
