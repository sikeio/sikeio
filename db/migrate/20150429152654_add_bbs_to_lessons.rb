class AddBbsToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :bbs, :string
  end
end
