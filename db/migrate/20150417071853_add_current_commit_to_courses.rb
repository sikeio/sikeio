class AddCurrentCommitToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :current_commit, :string
  end
end
