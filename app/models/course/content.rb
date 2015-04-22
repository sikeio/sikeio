class Course::Content

  attr_reader :course, :course_name, :xml_dom, :version

  def initialize(course, version = nil)
    @course = course
    @course_name = course.name
    @version = version
    @xml_dom =Nokogiri::HTML(xml_file_content)
  end

  #{:desc =>"desc", :title => "title"}
  def course_info
    {
      desc: nil,
      title: course_title
    }
  end

  #[{:name => "name", :title => "title", :overview => "overview" }, {...}]
  #return in order
  def lessons_info
    return @lessons_info if @lessons_info

    @lessons_info = []

    index_dom.css("week").sort.each do |week_node|
      week_lessons = week_lessons_sort_by_day(week_node)
      week_lessons.each do |lesson_node|
        info = {}
        info[:title] = lesson_title(lesson_node["name"])
        info[:overview] = lesson_node.css("overview").children.to_xhtml.strip
        info[:name] = lesson_node["name"]
        @lessons_info << info
      end
    end

    @lessons_info
  end

  #[{:name => "name", :title => "title"}]
  #without order
  def extra_lessons_info
    return @extra_lessons_info if @extra_lessons_info

    lesson_names = index_dom.css("lesson").map { |node| node["name"] }
    extra_node = xml_dom.css("page").find_all do |page_node|
      lesson_names.all?{ |lesson_name| lesson_name != page_node["name"] }
    end

    @extra_lessons_info = extra_node.map do |node|
      {:name => node["name"], :title => node.css("h1")[0].text}
    end
  end


  #[{:title => "title", :overview => "overview"}, {...}]
  #return in order
  def weeks_info
    return @weeks_info if @weeks_info
    @weeks_info = []
    index_dom.css("week").sort.each do |week_node|
      info = {}
      title = week_node.css("> h2")[0].text
      overview_node = week_node.css("> overview")[0]
      overview = overview_node ? overview_node.children.to_xhtml : ""
      info[:title] = title
      info[:overview] = overview

      @weeks_info << info
    end

    @weeks_info
  end


  #{lesson_name => day, lesson_name2 => day2}
  def release_day_of_lesson
    return @release_day_of_lesson if @release_day_of_lesson

    @release_day_of_lesson = {}
    week_num = 0
    index_dom.css("week").each do |week_node|
      week_node.css("lesson").each do |lesson_node|
        lesson_release_day = 7 * week_num + lesson_node["day"].to_i
        @release_day_of_lesson[lesson_node["name"]] = lesson_release_day
      end
      week_num += 1
    end
    @release_day_of_lesson
  end

  #[[lesson1_name,lesson2_name],[]]
  #return in order
  def course_weeks
    return @course_weeks if @course_weeks
    @course_weeks = index_dom.css("week").sort.map do |week_node|
      week_lessons = week_lessons_sort_by_day(week_node)
      week_lessons.map do |lesson_node|
        lesson_node["name"]
      end
    end
  end

  def lesson_content(lesson_name)
    index_dom.css("page[name=#{lesson_name}]")[0].children.to_xhtml
  end

  private

  def week_lessons_sort_by_day(week_node)
    week_node.css("lesson").sort_by do |lesson_node|
      lesson_node["day"].to_i
    end
  end

  def lesson_nodes_sort_by_day(lesson_nodes)
    lesson_nodes.sort_by do |lesson_node|
      lesson_node["day"].to_i
    end

  end

  def xml_file_content
    Course::FileReader.new(course, version).read_file
  end

  def course_title
    xml_dom.css("course")[0]["name"]
  end

  def lesson_title(lesson_name)
    page_node = xml_dom.css("page[name=#{lesson_name}]")[0]
    page_node.css("h1")[0].text
  end

  def index_dom
    @index_dom ||= xml_dom.css("index")[0]
  end

end
