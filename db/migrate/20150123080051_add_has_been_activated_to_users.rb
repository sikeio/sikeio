class AddHasBeenActivatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_been_activated, :bool,default: false
  end
end
