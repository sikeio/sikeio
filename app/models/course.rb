class Course < ActiveRecord::Base

  validates :name,presence: true

  def include_user?(user)
    participants.include? user.id
  end

end
