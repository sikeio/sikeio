class AddPartnershipNameToCourseInvite < ActiveRecord::Migration
  def change
    add_column :course_invites, :partnership_name, :string
  end
end
