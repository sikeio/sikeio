class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :course, index: true
      t.string :version
      t.datetime :start_time, null: false, :default => Time.now
      t.datetime :enroll_time, null:false, :default => Time.now

      t.timestamps null: false
    end
  end
end
