class AddInfoToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :info, :json
  end
end
