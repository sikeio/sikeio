class Course::Content


  attr_reader :course_name, :course_version, :xml_doc

  def initialize(name, version)
    raise "course is nil or current_version is not set" unless  (name && version)
    @course_name = name
    @course_version = version
    @xml_doc = xml_handle
  end

  # {desc => "", title => ""}
  def course_info
    {
      desc: nil,
      title: course_title,
    }
  end

  #{lesson_name1 => 1, lesson_name2 => 2}
  def lesson_numbers
    return @lesson_numbers if @lesson_numbers
    @lesson_numbers = {}
    number = 0
    xml_doc.css("lesson").sort.each do |lesson_node|
      number += 1
      @lesson_numbers[lesson_node["name"]] = number
    end
    @lesson_numbers
  end

  #{lesson_name -> {title -> title, overview -> "overview"}, lesson_name2 -> {title -> title, overview -> "overview"}}
  def lessons_info
    return @lessons_info if @lessons_info
    @lessons_info = {}
    xml_doc.css("lesson").each do |lesson_node|
      info = {}
      info["title"] = lesson_title(lesson_node["name"])
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
    xml_doc.css("week").each do |week_node|
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
    @lessons_sum = xml_doc.css("lesson").size
  end

  #[[lesson1_name,lesson2_name],[]]
  def course_weeks
    return @course_weeks if @course_weeks
    @course_weeks = xml_doc.css("week").map do |week_node|
      one_week = week_node.css("lesson").map do |lesson_node|
        lesson_node["name"]
      end
    end
  end



  #[week1_title, week2_title]
  def course_week_titles
    return @course_week_titles if @course_week_titles
    @course_week_titles = xml_doc.css("week h2").map { |week_h2_node| week_h2_node.text }
  end

  def course_week_overviews
    return @course_week_overviews if @course_week_overviews
    @course_week_overviews = {}
    week_num = 0
    xml_doc.css("week").each do |week_node|
      week_num += 1
      week_node.css("> overview").each do |overview_node|
        @course_week_overviews["week#{week_num}"] = overview_node.children.to_xhtml
      end
    end
    @course_week_overviews
  end

  def course_weeks_sum
    return @course_weeks_sum if @course_weeks_sum
    @course_weeks_sum = xml_doc.css("week").size
  end

  def extra_lessons_info
    return @extra_lessons_info if @extra_lessons_info
    lesson_names = xml_doc.css("lesson").map { |node| node["name"] }
    extra_node = Nokogiri::HTML(xml_file_content).css("page").find_all do |page_node|
      lesson_names.all?{ |lesson_name| lesson_name != page_node["name"] }
    end
    @extra_lessons_info = extra_node.map do |node|
      {:name => node["name"], :title => node.css("h1")[0].text}
    end
  end

  private

  def xml_file_content
    f = Course::FileReader.new(course_name, course_version)
    result = f.read_file
    result
  end

  def xml_handle
    Nokogiri::HTML(xml_file_content).css("index")[0]
  end

  def lesson_title(lesson_name)
    page_node = Nokogiri::HTML(xml_file_content).css("page[name=#{lesson_name}]")[0]
    title = page_node.css("h1")[0].text
  end

  def course_title
    Nokogiri::HTML(xml_file_content).css("course")[0]["name"]
  end

  def lesson_title(lesson_name)
    page_node = Nokogiri::HTML(xml_file_content).css("page[name=#{lesson_name}]")[0]
    title = page_node.css("h1")[0].text
  end

end
