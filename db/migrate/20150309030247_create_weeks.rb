class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.string :title
      t.integer :num
      t.references :course, index:true

      t.timestamps null: false
    end
  end
end
