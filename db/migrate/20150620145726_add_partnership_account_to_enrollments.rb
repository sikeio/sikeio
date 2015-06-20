class AddPartnershipAccountToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :partnership_account, :string
  end
end
