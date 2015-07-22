class AddExtraInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :introduce, :text
    add_column :users, :activated, :boolean
    add_column :users, :sent_welcome_email, :datetime
  end
end
