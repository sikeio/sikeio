class AddDiscourseUserInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :discourse_user_id, :integer
    add_column :users, :discourse_username, :string
  end
end
