class AddColorToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :color, :string
  end
end
