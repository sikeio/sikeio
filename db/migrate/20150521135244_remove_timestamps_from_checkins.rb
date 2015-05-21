class RemoveTimestampsFromCheckins < ActiveRecord::Migration
  def change
    remove_column  :checkins, :timestamps
  end
end
