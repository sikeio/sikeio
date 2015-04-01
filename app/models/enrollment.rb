# == Schema Information
#
# Table name: enrollments
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  course_id          :integer
#  version            :string
#  current_lesson_num :integer
#  start_time         :datetime         default(Mon, 16 Mar 2015 20:45:17 CST +08:00), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  token              :string

class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true, uniqueness: {scope: :user_id}
  before_create :fill_in_token
  has_many :checkouts, dependent: :destroy

  def invitation_path
    "/enrollments/#{self.id}?token=#{self.token}"
  end

  def invitation_url
    "http://localhost:3000/enrollments/#{self.id}?token=#{self.token}"
  end

  def next_uncompleted_lesson
    #得到尚未完成的第一个课程
    result = course.lessons.find do |lesson|
      !(Checkout.check_out?(self, lesson))
    end
  end

  def current_lesson
    return nil if all_completed? || (!any_released?)
    lesson = next_uncompleted_lesson
    return lesson if is_released?(lesson)
    lesson = course.pre_lesson(lesson) while !(is_completed?(lesson))
    lesson
  end

  def is_next_uncompleted_lesson?(lesson)

    lesson == next_uncompleted_lesson
  end

  def course
    target_course = Course.find(self.course_id)
    target_course.current_version = self.version if self.version
    target_course
  end

  def completed_lessons_num
    self.checkouts.count
  end

  def all_completed?
    course.lessons.all? do |lesson|
      Checkout.check_out?(self, lesson)
    end
  end

  def uncompleted_lesson_day_left
    lesson = course.next_lesson(self.next_uncompleted_lesson)
    next_lesson_start_day = course.release_day_of_lesson(lesson)

    next_lesson_start_day - day_from_start_time
  end

  def is_released?(lesson)
    day = self.course.release_day_of_lesson(lesson)
    day_from_start_time >= day
  end

  def any_released?
    first_lesson = self.course.lessons.first
    self.is_released? first_lesson
  end

  def is_completed?(lesson)
      Checkout.check_out?(self, lesson)
  end

  private

  def day_from_start_time
    today = Time.now.beginning_of_day.to_date
    course_start_time = self.start_time.beginning_of_day.to_date
    (today - course_start_time).to_i + 1
  end

  def fill_in_token
    self.token = SecureRandom.urlsafe_base64
  end

end
