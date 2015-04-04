class Course::MdParse

  WEEK_HEADER = "h2"
  COURSE_TITLE_HEADER = "h1"

  def initialize(repo_dir)
    raise "repo does not exist" if !File.exist?(repo_dir)
    @course_base_dir = repo_dir #Pathname
    course_index = @course_base_dir + "index.xmd"
    @lesson_names = compile(course_index).css("lesson").map { |node| node["name"] }
    @course_name = compile(course_index).css("h1")[0].text
  end

  def result

    course =<<-THERE
    <course name="#{@course_name}">
      #{index_xml}
      #{pages_xml}
    </course>
    THERE
  end

  def index_xml
    <<-THERE
    <index>
      #{weeks_xml}
    </index>
    THERE
  end

  def weeks_xml
    weeks = ""
    xml = compile(@course_base_dir + "index.xmd")
    node = xml.child.child
    nodes_in_week = nil
    while node
      if node.name == WEEK_HEADER
        if nodes_in_week
          week = <<-THERE
            <week>
              #{nodes_in_week}
            </week>
          THERE
          weeks << week
        end
        nodes_in_week = ""
        nodes_in_week << node.to_xhtml
      elsif node.name == "lesson"
        lesson = <<-THERE
        <lesson day="#{node["day"]}"  name="#{node["name"]}">
           <overview>#{node.children.to_xhtml}</overview>
        </lesson>
        THERE
        nodes_in_week << lesson if nodes_in_week
      else
        nodes_in_week << node.to_xhtml if nodes_in_week
      end
      node = node.next_sibling
      if node == nil
        week = <<-THERE
         <week>
           #{nodes_in_week}
         </week>
        THERE
        weeks << week
      end
    end


    <<-THERE
    #{weeks}
    THERE
  end

  def pages_xml
    pages = ""
    @lesson_names.each do |lesson_name|
      file_xml = nil
      file_path = @course_base_dir + lesson_name + "index.md"
      if File.exists?(file_path)
        file_xml = compile(file_path)
      else
        file_path = @course_base_dir + lesson_name + "index.xmd"
        file_xml = compile(file_path)
      end
      page = <<-THERE
      <page name="#{lesson_name}">
      #{file_xml.children.to_xhtml}
      </page>
      THERE
      pages << page
    end

    <<-THERE
    #{pages}
    THERE
  end

  def compile(file)
    if File.extname(file) == ".xmd"
      compile_xmd(file)
    else
      compile_md(file)
    end

  end

  def compile_xmd(file)
    str = %x{ xmd #{file} }
    Nokogiri::HTML(str).css("body")[0]
  end

  def compile_md(file)
    str = %x{ marked -i #{file} }
    Nokogiri::HTML(str).css("body")[0]
  end


end
