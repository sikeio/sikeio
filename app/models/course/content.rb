class Course::Content

  def initialize(course_name, version)
    raise "course is nil or current_version is not set" unless  (course_name && version)
    @course_name = course_name
    @version = version
    @xml_doc = xml_handle
  end

  def course_info
    {desc: nil}
  end

  #{lesson_name -> {title -> title, overview -> "overview", lesson_name2 -> {title -> title, overview -> "overview"}}
  def lessons_info
    return @lessons_info if @lessons_info
    @lessons_info = {}
    @xml_doc.css("lesson").each do |lesson_node|
      info = {}
      info["title"] = lesson_node["title"]
      info["overview"] = lesson_node.css("overview").children.to_xhtml.strip
       @lessons_info[lesson_node["name"]] = info
    end
    @lessons_info
  end

  #{lesson_name => day, lesson_name2 => day2}
  def release_day_of_lesson
    return @release_day_of_lesson if @release_day_of_lesson

    @release_day_of_lesson = {}
    week_num = 0
    @xml_doc.css("week").each do |week_node|
      week_node.css("lesson").each do |lesson_node|
        lesson_release_day = 7 * week_num + lesson_node["day"].to_i
        @release_day_of_lesson[lesson_node["name"]] = lesson_release_day
      end
      week_num += 1
    end
    @release_day_of_lesson
  end

  def lessons_sum
    return @lessons_sum if @lessons_sum
    @lessons_sum = @xml_doc.css("lesson").size
  end

  #[[lesson1_name,lesson2_name],[]]
  def course_weeks
    return @course_weeks if @course_weeks
    @course_weeks = @xml_doc.css("week").map do |week_node|
      one_week = week_node.css("lesson").map do |lesson_node|
        lesson_node["name"]
      end
    end
  end

  #[week1_title, week2_title]
  def course_week_titles
    return @course_week_titles if @course_week_titles
    @course_week_titles = @xml_doc.css("week").map { |week_node| week_node["title"] }
  end

  def course_weeks_sum
    return @course_weeks_sum if @course_weeks_sum
    @course_weeks_sum = @xml_doc.css("week").size
  end

  private
  def repo_path
    Rails.root + "xml_repo" + @course_name
  end

  def xml_file_content
    file = @course_name + ".xml"
    git_repo = Git.open(repo_path)
    git_repo.show(@version, file)
  end

  def xml_handle
    Nokogiri::HTML(xml_file_content).css("index")[0]
  end
end
