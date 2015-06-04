# == Schema Information
#
# Table name: course_invites
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_time :datetime
#

class CourseInvite < ActiveRecord::Base
  belongs_to :course

  validates_uniqueness_of :token

  before_save do
    self.token = SecureRandom.hex if self.token == nil
  end


  def start_at_this_week
    self.update(start_time: this_monday)
  end

  private

  def this_monday
    Time.now.beginning_of_week
  end
end
