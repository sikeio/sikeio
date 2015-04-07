class AddRepoUrlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :repo_url, :string
  end
end
