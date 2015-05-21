class AddRailsTimestampsToCheckins < ActiveRecord::Migration
  def change
    add_timestamps(:checkins)
  end
end
