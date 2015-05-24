class CourseInvite < ActiveRecord::Base
  belongs_to :course

  validates_uniqueness_of :token

  before_save do
    self.token = SecureRandom.hex
  end


  def start_at_this_week
    self.update(start_time: this_monday)
  end

  private

  def this_monday
    Time.now.beginning_of_week
  end
end
