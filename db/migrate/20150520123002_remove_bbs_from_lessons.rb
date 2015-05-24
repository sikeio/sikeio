class RemoveBbsFromLessons < ActiveRecord::Migration
  def change
    remove_column :lessons, :bbs
  end
end
