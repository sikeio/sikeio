class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.belongs_to :enrollment, index: true
      t.string :lesson_name

      t.timestamps null: false
    end
  end
end
