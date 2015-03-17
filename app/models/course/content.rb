class Course::Content 

  def initialize(course, version)
    @course = course
    @version = version
    parse_xml_file! if @version && @course
  end

  def repo_path
    path = Rails.root + @course.name + @version
  end

  def version=(new_version)
    @version = new_version
    begin
      parse_xml_file!
    rescue
    end
  end

  def version
    @version
  end

  def xml_file_path
    file = @course.name 
    repo_path + (@course.name + ".xml")
  end

  def lessons
    @lessons
  end

  def lessons_sum
    @lessons_sum
  end

  def course_weeks
    @course_weeks
  end

  def course_week_titles
    @course_week_titles
  end

  def course_weeks_sum
    @course_weeks_sum
  end

  private

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
        @course_week_titles << week_node["title"]
        week_node.css('lesson').each do |lesson_node|
          day = lesson_node["day"].to_i
          lesson_name = lesson_node["name"]
          day_lesson = Lesson.find_by_name(lesson_name)
          lesson = [day_lesson, day]
          course_week_lessons << lesson
          @lessons << day_lesson
        end
        @course_weeks << course_week_lessons
      end
    end
    @lessons_sum = @lessons.size
    @course_weeks_sum = @course_weeks.size
  end
end
