class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :desc
      t.integer :participants,array: true,default: []

      t.timestamps null: false
    end
  end
end
