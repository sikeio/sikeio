# == Schema Information
#
# Table name: enrollments
#
#  id                        :integer          not null, primary key
#  user_id                   :integer          not null
#  course_id                 :integer          not null
#  version                   :string
#  start_time                :datetime
#  enroll_time               :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  token                     :string           not null
#  personal_info             :json
#  activated                 :boolean          default(FALSE)
#  has_sent_invitation_email :boolean          default(FALSE)
#  paid                      :boolean          default(FALSE)
#  buddy_name                :string
#

class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :token, presence: true
  validates :user_id, presence: true
  validates :course_id, presence: true, uniqueness: {scope: :user_id}
  has_many :checkins

  scope :activated, -> {where(activated: true)}

  before_validation {
    self.reset_token if self.token.nil?
  }

  def to_param
    self.token
  end

  def has_personal_info?
    !self.personal_info.nil?
  end

  def schedule
    @schedule ||= Enrollment::Schedule.new(self)
  end

  def reset_token
    self.token = SecureRandom.urlsafe_base64
  end

  def start!
    # next monday at 0:00
    self.start_time = next_monday
    self.activated = true
    self.save!
  end

  private

  def next_monday
    Time.now.next_week :monday
  end

end
