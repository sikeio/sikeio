class AddReleaseStatusColumnToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :release_status, :boolean, :default => false
  end
end
