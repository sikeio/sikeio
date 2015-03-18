class CreateCheckOuts < ActiveRecord::Migration
  def change
    create_table :check_outs do |t|
      t.belongs_to :enrollment, index: true
      t.string :lesson_name

      t.timestamps null: false
    end
  end
end
