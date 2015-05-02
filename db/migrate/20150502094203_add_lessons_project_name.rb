class AddLessonsProjectName < ActiveRecord::Migration
  def change
    add_column :lessons, :project, :string
  end
end
