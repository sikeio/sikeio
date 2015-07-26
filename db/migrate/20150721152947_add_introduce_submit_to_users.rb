class AddIntroduceSubmitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :introduce_submit, :boolean
    add_column :users, :introduce_submit_enrollment, :string
  end
end
