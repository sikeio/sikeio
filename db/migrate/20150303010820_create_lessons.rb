class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.integer :day
      t.string :title
      t.text :overview

      t.references :week, index:true

      t.timestamps null: false
    end
  end
end
