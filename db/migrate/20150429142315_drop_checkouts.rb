class DropCheckouts < ActiveRecord::Migration
  def up
    drop_table :checkouts
  end

  def down
      create_table :checkouts do |t|
      t.belongs_to :enrollment, index: true
      t.string :lesson_name

      t.timestamps null: false
    end
  end
end
