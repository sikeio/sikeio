class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true
      t.belongs_to :course, index: true
      #用户正在进行的课程
      t.integer :current_lesson_num, :default  => 1
      #系统已经开放的课程
      t.datetime :start_time, null: false, :default => Time.now

      t.timestamps null: false
    end
  end
end
