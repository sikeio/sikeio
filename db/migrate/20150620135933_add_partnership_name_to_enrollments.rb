class AddPartnershipNameToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :partnership_name, :string
  end
end
