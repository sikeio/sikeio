class Course::MdParse

  WEEK_HEADER = "h2"
  COURSE_TITLE_HEADER = "h1"

  attr_reader :course_base_dir, :version, :sha, :temp_dir

  def initialize(repo_dir, version = "master")
    raise "repo does not exist" if !File.exist?(repo_dir)
    @version = version
    @course_base_dir = repo_dir #Pathname
    @temp_dir = Course::Utils::TEMP_DIR
    @sha = SecureRandom.hex
    save_file_in_temp
  end

  def course_name
    @course_name ||= course_index_dom.css("h1")[0].text
  end

  def lesson_names
    @lesson_names ||= course_index_dom.css("lesson").map { |node| node["name"] }
  end

  def course_index_dom
    index_file = sha + "index.xmd"
    course_index_file_path = temp_dir + index_file
    compile(course_index_file_path)
  end

  def result
    course =<<-THERE
    <course name="#{course_name}">
      #{index_xml}
      #{pages_xml}
    </course>
    THERE
    clear_temp_dir
    course
  end

  def clear_temp_dir
    Dir.chdir(temp_dir) do
      list = Dir.glob("#{sha}*")
      puts sha
      puts list
      FileUtils.rm_rf(list)
    end

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
    xml = course_index_dom
    node = xml.child
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

  def lesson_dom(lesson_name)
    dom = nil
    file = sha + "index.md"
    lesson_dir = sha + lesson_name
    file_path = temp_dir + lesson_dir + file
    if File.exists?(file_path)
    else
      file = sha + "index.xmd"
      file_path = temp_dir + lesson_dir + file
    end
    dom = compile(file_path)
    dom
  end

  def pages_xml
    pages = ""
    lesson_names.each do |lesson_name|
      lesson_xml_dom = lesson_dom(lesson_name)
      page = <<-THERE
      <page name="#{lesson_name}">
      #{lesson_xml_dom.children.to_xhtml}
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
    Nokogiri::HTML(str).css("body")[0].child
  end

  def compile_md(file)
    str = %x{ marked -i #{file} }
    Nokogiri::HTML(str).css("body")[0]
  end


  def save_file_in_temp
    save_course_index
    save_lesson_index
  end

  def save_course_index
    git = Git.open(course_base_dir)
    FileUtils::mkdir_p(temp_dir)
    git.branch(version).gcommit.gtree.files.each do |file_name, file|
      temp_file_name = sha + file_name
      f = File.new(temp_dir + temp_file_name, "w")
      f.write(file.contents)
      f.close
    end
  end

  def save_lesson_index
    git = Git.open(course_base_dir)
    git.branch(version).gcommit.gtree.trees.each do |dir_name, dir|
      dir.files.each do |file_name, file|
        temp_dir_name = sha + dir_name
        FileUtils::mkdir_p(temp_dir + temp_dir_name)
        temp_file_name = sha + file_name
        f = File.new(temp_dir + temp_dir_name + temp_file_name, "w")
        f.write(file.contents)
        f.close
      end
    end
  end
end
