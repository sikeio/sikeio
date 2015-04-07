class AddTokenToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :token, :string
  end
end
