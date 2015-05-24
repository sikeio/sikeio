class CourseInvite < ActiveRecord::Base
  belongs_to :course

  validates_uniqueness_of :token

  before_save do
    self.token = SecureRandom.hex
  end
end
