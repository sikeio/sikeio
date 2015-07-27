class AddJobInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :string
    add_column :users, :curriculum_vitae_url, :string
  end
end
