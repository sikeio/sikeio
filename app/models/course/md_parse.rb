class Course::MdParse

  WEEK_HEADER = "h2"
  COURSE_TITLE_HEADER = "h1"

  def initialize(repo_dir)
    raise "repo does not exist" if !File.exist?(repo_dir)
    @course_base_dir = repo_dir #Pathname
    @lesson_names = []
    @course_name
  end

  def result
    course = course_framework.child
    document = course.document
    index = course_index(course_index_xmd_output, document)
    course.add_child(index)
    @lesson_names.each do |lesson_name|
      page_node = lesson_page(document, lesson_name)
      course.add_child(page_node)
    end
    course["name"] = @course_name
    course
  end

  def course_index_xmd_output
    course_index_xmd_path = @course_base_dir + "index.xmd"
    str = %x{ xmd #{course_index_xmd_path} }
    result = Nokogiri::HTML(str)
    result.css("body")[0]
  end

  def course_index(xml, document)
    index_node = node("index", document)
    parse_course_index(xml, index_node)
    index_node
  end

  def parse_course_index(xml, index_node)
    document = index_node.document
    xml_weeks = unparsed_weeks(xml, document)
    xml_weeks.each do |xml_week|
      week_node = course_week(xml_week, document)
      index_node.add_child(week_node)
    end
  end

  def course_week(xml_week, document)
    week_node = node("week", document)
    parse_course_week(xml_week, week_node)
    week_node
  end

  def parse_course_week(xml_week, week_node)
    document = week_node.document
    parse_week_head(xml_week, week_node)
    xml_lessons = unparsed_week_lessons(xml_week, document)
    if xml_lessons != []
      xml_lessons.each do |xml_lesson|
        lesson_node = week_lesson(xml_lesson, document)
        week_node.add_child(lesson_node)
      end
    end
  end

  def week_lesson(xml_lesson, document)
    lesson_node = xml_lesson.dup
    @lesson_names << lesson_node["name"]
    if lesson_node.child != nil
      lesson_overview_node = node("overview", document)
      lesson_node.children.each do |child_node|
        lesson_overview_node.add_child(child_node.dup)
        child_node.remove
      end
      lesson_node.add_child(lesson_overview_node)
    end
    lesson_node
  end

  def parse_week_head(xml_week, week_node)
    week_node.add_child(xml_week.child.dup)
    week_overview = xml_week.css("overview")[0]
    if week_overview
      week_node.add_child(week_overview.dup)
    end
  end

  def unparsed_week_lessons(xml_week, document)
    temp_xml_week = xml_week.dup
    temp_xml_week.css("lesson").sort.find_all { |lesson_node| lesson_node["name"] != nil }
  end

  def unparsed_weeks(xml, document)
    week_node = nil
    content_node = xml.child.child
    week_nodes = []
    while content_node
      if content_node.name == WEEK_HEADER
        if week_node != nil
          week_nodes << week_node
        end
        week_node = node("week", document)
        week_node.add_child(content_node.dup)
      else
        if content_node.name == COURSE_TITLE_HEADER
          @course_name = content_node.text
        end
        if week_node != nil
          week_node.add_child(content_node.dup)
        end
      end
      content_node = content_node.next_sibling
    end
    if week_node != nil
      week_nodes << week_node
    end
    week_nodes
  end

  def course_framework
    xml = Nokogiri::HTML("<html></html>")
    xml = xml.css("html")[0]

    course_node = node("course", xml.document)
    xml.add_child(course_node)
    xml
  end

  def node(node_name, document)
    Nokogiri::XML::Node.new(node_name, document)
  end

  def lesson_md_output(lesson_name)
    file_path = @course_base_dir + lesson_name + "index.md"
    output_xml = nil
    if File.exist?(file_path)
      str = %x{ marked -i #{file_path} }
      output_xml = Nokogiri::HTML(str).css("body")[0]
    else
      file_path = @course_base_dir + lesson_name + "index.xmd"
      if File.exist?(file_path)
      str = %x{ xmd #{file_path} }
      output_xml = Nokogiri::HTML(str).css("body")[0]
      end
    end
    output_xml
  end

  def lesson_page(document, lesson_name)
    md_output = lesson_md_output(lesson_name)
    if md_output != nil
      page_node = node("page", document)
      page_node["name"] = lesson_name
      md_output.children.each {|child_node| page_node.add_child(child_node.dup) }
    end
    page_node
  end


end
