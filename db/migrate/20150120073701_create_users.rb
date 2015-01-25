class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :activation_token
      t.json :personal_info
      t.integer :courses,array: true,default: []

      t.timestamps null: false
    end
  end
end
