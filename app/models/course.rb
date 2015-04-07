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

  attr_reader :content_version

  has_many :enrollments, dependent: :restrict_with_exception

  has_many :users, through: :enrollments

  validates :name, presence: true,
    format: {with: /\A[a-zA-Z0-9\-_]+\z/},
    uniqueness: true
  validates_uniqueness_of :permalink

  after_initialize do
    self.content_version = self.current_version
  end

  def to_param
    self.permalink
  end

  def lessons  #根据先后顺序排序好的
    lessons = []
    content.lessons_info.each do |lesson_name, other_attr|
      lessons << Lesson.find_by_name(lesson_name)
    end
    lessons
  end

  def lesson_number(lesson)
    content.lesson_numbers[lesson.name]
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

  def course_lesson(lesson_permalink)
    lessons.find { |lesson| lesson.permalink == lesson_permalink }
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

  def release_day_of_lesson(lesson)
    content.release_day_of_lesson[lesson.name]
  end

  def content_version=(version)
    if version == self.current_version
      @content_version = nil
    else
      @content_version = version
    end
    set_first_time_set_version(true)
  end

  def test_content
    content
  end

  private

  #why accessor does not work
  def set_first_time_set_version(bool)
    @first_time_set_version = bool
  end

  def first_time_set_version
    @first_time_set_version
  end

  def content
    if first_time_set_version
      if content_version
        @content = Content.new(self.name, content_version)
      else
        @content = Content.new(self.name, self.current_version)
      end
      set_first_time_set_version(false)
    end
    @content
  end
end
