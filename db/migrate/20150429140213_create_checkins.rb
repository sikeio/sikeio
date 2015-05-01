class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.belongs_to :enrollment, index:true
      t.text :problem
      t.string :github_repository
      t.integer :time_cost
      t.integer :degree_of_difficulty
      t.references :lesson, :index => true
    end
  end
end
