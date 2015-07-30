class AddJobInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :string
    add_column :users, :resume_url, :string
  end
end
