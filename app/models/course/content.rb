class Course::Content

  def initialize(course)
    @course = course
    parse_xml_file! if @course && @course.current_version
  end

  #[{lesson_name -> {day -> 1, title -> title, overview -> "overview"},,,,]
  def lessons_info
    @lessons_info
  end

  def release_day_of_lesson
    @release_day
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

  def repo_path
    path = Rails.root + @course.name + @course.current_version
  end

  def xml_file_path
    file = @course.name 
    repo_path + (@course.name + ".xml")
  end


  def parse_xml_file!
    raise "Error: #{xml_file_path} does not exist" if !File.exist?(xml_file_path)
    #--get xml content ---
    xml_doc = xml_handle

    parse_lessons_info xml_doc
    parse_lessons_sum xml_doc
    parse_release_day_of_lesson xml_doc

    parse_course_weeks xml_doc
    parse_week_titles xml_doc
    parse_course_sum xml_doc 
  end

  #[{lesson_name -> {title -> title, overview -> "overview"},,,,]
  def parse_lessons_info(xml_doc)
    @lessons_info = []

    @lessons_info = xml_doc.css("lesson").map do |lesson_node|
      info = {}
      info["title"] = lesson_node["title"]
      info["overview"] = lesson_node.css("overview").text.strip
      { lesson_node["name"] => info }
    end
  end

  #{lesson_name_1 => day, lesson_name_2 => day2}
  def parse_release_day_of_lesson(xml_doc)
    @release_day = {}
    week_num = 0
    xml_doc.css("week").each do |week_node|
      week_node.css("lesson").each do |lesson_node|
        release_day = 7 * week_num + lesson_node["day"].to_i
        @release_day[lesson_node["name"]] = release_day 
      end
      week_num += 1
    end
  end

  def parse_lessons_sum(xml_doc)
    @lessons_sum = xml_doc.css("lesson").size
  end

  def parse_course_sum(xml_doc)
    @course_weeks_sum = xml_doc.css("week").size
  end

  def parse_week_titles(xml_doc)
    @course_week_titles = xml_doc.css("week").map { |week_node| week_node["title"] }
  end

  #[[lesson1_name,lesson2_name],[]]
  def parse_course_weeks(xml_doc)
    @course_weeks = xml_doc.css("week").map do |week_node|
      one_week = week_node.css("lesson").map do |lesson_node|
        lesson_name = lesson_node["name"]
      end
    end
  end

  def xml_handle
    f = File.open(xml_file_path)
    xml = Nokogiri::XML(f)
    f.close
    xml
  end

end
