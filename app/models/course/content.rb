# Represents the compiled course.xml
class Course::Content

  attr_reader :course, :course_name, :version

   def self.memoize(*method_syms)
    for sym in method_syms
      module_eval <<-THERE
        alias_method :__#{sym}__, :#{sym}
        private :__#{sym}__
        def #{sym}(*args, &block)
          @__#{sym}__ ||= __#{sym}__(*args, &block)
        end
        THERE
    end
  end

  def initialize(course, version = nil)
    raise "course is not yet compiled: Course(#{course.id})" if !course.compiled?
    @course = course
    @course_name = course.name
    @version = version
  end

  def xml_dom
    Nokogiri::HTML(xml)
  end
  memoize :xml_dom

  def xml
    File.read course.xml_path
  end
  memoize :xml

  def page_dom(name)
    xml_dom.css("page[name=#{name}]")[0]
  end

  #{:desc =>"desc", :title => "title"}
  def course_info
    {
      desc: nil,
      title: course_title
    }
  end
  memoize :course_info

  #[{:name => "name", :title => "title", :overview => "overview",:bbs =>"http://.." ,:discourse_topic_id => ""}, {...}]
  #return in order
  def lessons_info
    temp_lessons_info = []

    index_dom.css("week").sort.each do |week_node|
      week_lessons = week_lessons_sort_by_day(week_node)
      week_lessons.each do |lesson_node|
        name = lesson_node["name"]
        temp_lessons_info << lesson_info(name)
      end
    end

    temp_lessons_info
  end

  #
  def position_of_lesson(name)
    if i = lessons_info.index { |info| info[:name] == name }
      return i + 1
    end

    raise "cannot find lesson position by name: #{name}"
  end

  memoize :lessons_info

  def lesson_info(name)
    node = xml_dom.css("lesson[name=#{name}]").first
    info = {}
    info[:title] = lesson_title(node["name"])
    info[:overview] = node.css("overview").children.to_xhtml.strip
    info[:name] = node["name"]
    info[:project] = node["project"]
    if (!node["bbs"].blank?)
      info[:bbs] = node["bbs"]
      path = URI.parse(node["bbs"]).path
      info[:discourse_topic_id] = path.split("/").last
    end
    return info
  end

  #[{:name => "name", :title => "title"}]
  #without order
  def extra_lessons_info

    lesson_names = index_dom.css("lesson").map { |node| node["name"] }
    extra_node = xml_dom.css("page").find_all do |page_node|
      lesson_names.all?{ |lesson_name| lesson_name != page_node["name"] }
    end

    extra_node.map do |node|
      {:name => node["name"], :title => node.css("h1")[0].text}
    end
  end
  memoize :extra_lessons_info


  #[{:title => "title", :overview => "overview"}, {...}]
  #return in order
  def weeks_info

    temp_weeks_info = []
    index_dom.css("week").sort.each do |week_node|
      info = {}
      title = week_node.css("> h2")[0].text
      overview_node = week_node.css("> overview")[0]
      overview = overview_node ? overview_node.children.to_xhtml : ""
      info[:title] = title
      info[:overview] = overview

      temp_weeks_info << info
    end

    temp_weeks_info
  end
  memoize :weeks_info


  #{lesson_name => day, lesson_name2 => day2}
  def release_day_of_lesson

    temp_release_day_of_lesson = {}
    week_num = 0
    index_dom.css("week").each do |week_node|
      week_node.css("lesson").each do |lesson_node|
        lesson_release_day = 7 * week_num + lesson_node["day"].to_i
        temp_release_day_of_lesson[lesson_node["name"]] = lesson_release_day
      end
      week_num += 1
    end
    temp_release_day_of_lesson
  end
  memoize :release_day_of_lesson

  #[[lesson1_name,lesson2_name],[]]
  #return in order
  def course_weeks
    index_dom.css("week").sort.map do |week_node|
      week_lessons = week_lessons_sort_by_day(week_node)
      week_lessons.map do |lesson_node|
        lesson_node["name"]
      end
    end
  end
  memoize :course_weeks

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

  def course_title
    xml_dom.css("course")[0]["name"]
  end

  def lesson_title(lesson_name)
    page_dom(lesson_name).css("h1").first.text
  end

  def index_dom
    @index_dom ||= xml_dom.css("index")[0]
  end
end
