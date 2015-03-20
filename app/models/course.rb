class Course < ActiveRecord::Base

  has_many :enrollments # dependent: :destroy 需要吗？
  has_many :users, through: :enrollments

  validates :name ,presence: true

 
  def lessons  #根据先后顺序排序好的
    lessons = []
    @content.lessons_info.each do |lesson_info|
      lesson_info.each_key do |lesson_name|
        lessons << Lesson.find_by_name(lesson_name)
      end
    end
    lessons
  end

  def next_lesson(lesson)
    index = @lessons.find_index { |var_lesson| lesson == var_lesson }
    @lessons[index + 1]
  end

  def lessons_sum
    @content.lessons_sum
  end

  def course_weeks #排序好的
    @content.course_weeks.map do |one_week|
      one_week.map { |lesson_name|  Lesson.find_by_name(lesson_name) }
    end
  end

  def course_week_titles
    @content.course_week_titles
  end

  def course_weeks_sum
    @content.course_weeks_sum
  end

  def current_version=(new_version)
    if new_version && @version != new_version
      @version = new_version
      @content = Content.new(self)
    end
  end

  def current_version
    @version
  end

  def release_day_of_lesson(lesson)
    @content.release_day_of_lesson[lesson.name]
  end


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

