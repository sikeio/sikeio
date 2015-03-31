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
  DEFAULT_VERSION = "v1"

  has_many :users, through: :enrollments

  validates :name, presence: true,
    format: {with: /\A[a-zA-Z0-9\-_]+\z/},
    uniqueness: true

  attr_reader :current_version

  after_initialize do |course|
    course.current_version = DEFAULT_VERSION unless course.current_version
  end


  def to_param
    self.name
  end

  def lessons  #根据先后顺序排序好的
    lessons = []
    content.lessons_info.each do |lesson_info|
      lesson_info.each_key do |lesson_name|
        lessons << Lesson.find_by_name(lesson_name)
      end
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

  def current_version=(new_version)
    if new_version && @current_version != new_version
      @current_version = new_version
      @content = nil
    end
  end

  def release_day_of_lesson(lesson)
    content.release_day_of_lesson[lesson.name]
  end

  private

  def content
    @content ||= Content.new(self)
  end

  #def self.update_lessons!(xml_file_path)
  #end
=begin
  def self.update_lessons!(xml_file_path)
    raise "Error: #{xml_file_path} does not exist" if !File.exist?(xml_file_path)
    #--get xml content ---
    f = File.open(xml_file_path)
    xml_doc = Nokogiri::XML(f)
    f.close


    #--parse xml and update DB--
    xml_doc.css('course').each do |course_node|

      #get course and lesson
      course_name = course_node["name"]
      unless Course.find_by_name(course_name)
        Course.create!(name: course_name)
      end

      course_node.css('week').each do |week_node|
        week_node.css('lesson').each do |lesson_node|
          overview_node = lesson_node.css('overview')

          #get all the info needed to update db
          lesson_name = lesson_node["name"]
          lesson_title = lesson_node["title"]
          lesson_overview = overview_node.text

          lesson_info = {
            name: lesson_name,
            title: lesson_title,
            overview: lesson_overview,
          }

          #create or update record
          (lesson = Lesson.find_by(name: lesson_name)) ? lesson.update!(lesson_info) : Lesson.create!(lesson_info)
        end
      end
    end
  end
=end
end

