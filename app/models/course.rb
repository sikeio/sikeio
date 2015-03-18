class Course < ActiveRecord::Base

  has_many :enrollments # dependent: :destroy 需要吗？
  has_many :users, through: :enrollments

  validates :name ,presence: true

  after_initialize do |course|
    parse_xml_file! if course.current_version
  end

=begin
  def self.release_lesson!
    Order.release_lesson!
  end
=end

  def lessons  #根据先后顺序排序好的
    @lessons
  end

  def next_lesson(lesson)
    index = @lessons.find_index { |var_lesson| lesson == var_lesson }
    @lessons[index + 1]
  end

  def lessons_sum
    @lessons_sum
  end

  def course_weeks #排序好的
    @course_weeks
  end

  def course_week_titles
    @course_week_titles
  end

  def course_weeks_sum
    @course_weeks_sum
  end

  def current_version=(new_version)
    @version = new_version
    parse_xml_file!
  end

  def current_version
    @version
  end

  def release_day_of_lesson(lesson)
    result_day = 0 #stand no lesson in this course
    @course_weeks.each do |course_week|
      target_lesson_info = course_week.find { |lesson_info| lesson_info[0].name == lesson.name } 
      if target_lesson_info
        result_day += target_lesson_info[1] # [1]里面存储的是课程所在周里第几天
      else
        result_day += 7
      end
    end
    result_day
  end

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

  private

  def repo_path
    Rails.root + self.name + @version
  end
  
  def xml_file_path
    repo_path + (self.name + ".xml")
  end


  def parse_xml_file!
    raise "Error: #{xml_file_path} does not exist" if !File.exist?(xml_file_path)
    #--get xml content ---
    f = File.open(xml_file_path)
    xml_doc = Nokogiri::XML(f)
    f.close

    #--parse xml and set value--
    @lessons = []
    @course_weeks = []
    @course_week_titles = []
    @lessons_sum = 0
    @course_weeks_sum = 0
    xml_doc.css('course').each do |course_node|

      #--get info-------------
      course_name = course_node["name"]

      course_node.css('week').each do |week_node|
        course_week_lessons = []
        temp_test_day = 0
        @course_week_titles << week_node["title"]
        week_node.css('lesson').each do |lesson_node|
          #因为xml文件中，一周内的day是递增的，所以可以用来判断是否有冲突
          day = lesson_node["day"].to_i
          raise "Error: lesson day conflict" if temp_test_day >= day
          lesson_name = lesson_node["name"]
          day_lesson = Lesson.find_by_name(lesson_name)
          lesson = [day_lesson, day]
          course_week_lessons << lesson
          @lessons << day_lesson
          temp_test_day = day
        end
        @course_weeks << course_week_lessons
      end
    end
    @lessons_sum = @lessons.size
    @course_weeks_sum = @course_weeks.size
  end
  
end

