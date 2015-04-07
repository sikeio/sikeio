class AddPermalinkToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :permalink, :string
  end
end
