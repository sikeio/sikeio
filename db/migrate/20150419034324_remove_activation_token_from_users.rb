class RemoveActivationTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :activation_token
  end
end
