# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string
#  desc       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Course < ActiveRecord::Base


  has_many :enrollments, dependent: :restrict_with_exception

  has_many :users, through: :enrollments


  validates :name, presence: true,
    format: {with: /\A[a-zA-Z0-9\-_]+\z/},
    uniqueness: true

  def to_param
    self.name
  end

  def lessons  #根据先后顺序排序好的
    lessons = []
    content.lessons_info.each do |lesson_name, other_attr|
      lessons << Lesson.find_by_name(lesson_name)
    end
    lessons
  end

  def next_lesson(lesson)
    index = self.lessons.find_index { |var_lesson| lesson == var_lesson }
    self.lessons[index + 1]
  end

  def pre_lesson(lesson)
    index = self.lessons.find_index { |var_lesson| lesson == var_lesson }
    self.lessons[index - 1]
  end

  def lessons_sum
    content.lessons_sum
  end

  def course_lesson(lesson_name)
    lessons.find { |lesson| lesson.name = lesson_name }
  end

  def course_weeks #排序好的
    content.course_weeks.map do |one_week|
      one_week.map { |lesson_name|  Lesson.find_by_name(lesson_name) }
    end
  end

  def course_week_titles
    content.course_week_titles
  end

  def course_weeks_sum
    content.course_weeks_sum
  end

  def user_course_version=(version = self.current_version)
    if @user_course_version != version
      @user_course_version = version
      @content = nil
    end
  end

  def user_course_version
    if @user_course_version
      return @user_course_version
    else
      self.current_version
    end
  end

  def release_day_of_lesson(lesson)
    content.release_day_of_lesson[lesson.name]
  end

  def content
      @content ||= Content.new(self.name, user_course_version)
  end
end

