class RemoveParticipantsColumnFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :participants, :integer
  end
end
