class AddTimestampsToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :timestamps, :datetime
  end
end
