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
  has_many :checkouts, dependent: :destroy

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

  def next_uncompleted_lesson
    #得到尚未完成的第一个课程
    result = schedule.lessons.find do |lesson|
      !(Checkout.check_out?(self, lesson))
    end
  end

  def current_lesson
    return nil if all_completed? || (!any_released?)
    lesson = next_uncompleted_lesson
    return lesson if is_released?(lesson)
    lesson = schedule.pre_lesson(lesson) while !(is_completed?(lesson))
    lesson
  end

  def is_next_uncompleted_lesson?(lesson)
    lesson == next_uncompleted_lesson
  end

  def schedule
    if !@schedule
      if self.version
        @schedule = self.course.schedule(self.version)
      else
        @schedule = self.course.schedule
      end
    end
    @schedule
  end

  def completed_lessons_num
    self.checkouts.count
  end

  def all_completed?
    schedule.lessons.all? do |lesson|
      Checkout.check_out?(self, lesson)
    end
  end

  def uncompleted_lesson_day_left
    lesson = schedule.next_lesson(self.next_uncompleted_lesson)
    next_lesson_start_day = schedule.release_day_of_lesson(lesson)

    next_lesson_start_day - day_from_start_time
  end

  def is_released?(lesson)
    day = schedule.release_day_of_lesson(lesson)
    day_from_start_time >= day
  end

  def any_released?
    first_lesson = schedule.lessons.first
    self.is_released? first_lesson
  end

  def is_completed?(lesson)
    Checkout.check_out?(self, lesson)
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

  def next_monday
    Time.now.next_week :monday
  end

  private

  def day_from_start_time
    today = Time.now.beginning_of_day.to_date
    course_start_time = self.start_time.beginning_of_day.to_date
    (today - course_start_time).to_i + 1
  end
end
