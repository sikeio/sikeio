class AddCurrentVersionToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :current_version, :string
  end
end
