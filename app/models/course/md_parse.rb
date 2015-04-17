class Course::MdParse

  WEEK_HEADER = "h2"
  COURSE_TITLE_HEADER = "h1"

  attr_reader :course_base_dir, :version, :temp_dir, :temp_file

  def initialize(repo_dir, version = "master")
    raise "repo does not exist" if !File.exist?(repo_dir)
    @version = version
    @course_base_dir = repo_dir #Pathname
    @temp_dir = Course::Utils::TEMP_DIR
    FileUtils.mkdir_p(Course::Utils::TEMP_DIR) if !File.exist?(Course::Utils::TEMP_DIR)
  end


  def result
    save_file_in_temp
    course =<<-THERE
    <course name="#{course_name}">
      #{index_xml}
      #{pages_xml}
    </course>
    THERE
    clear_temp_dir
    course
  end

  def current_commit_msg
    git = Git.open(course_base_dir)
    message = git.branch(version).gcommit.message
    sha = git .branch(version).gcommit.sha
    message + ": " + sha
  end

  private

  def course_name
    @course_name ||= course_index_dom.css("h1")[0].text
  end

  def lesson_names
    @lesson_names ||= course_index_dom.css("lesson").map { |node| node["name"] }
  end

  def course_index_dom
    file = temp_file["course"]
    compile(file)
  end

  def clear_temp_dir
    temp_file.each_value { |f| f.unlink }
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
    file = temp_file[lesson_name]
    dom = compile(file)
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
    if File.extname(file.path) == ".xmd"
      compile_xmd(file)
    else
      compile_md(file)
    end

  end

  def compile_xmd(file)
    str = IO.popen(["xmd", file.path]).read
    Nokogiri::HTML(str).css("body")[0].child
  end

  def compile_md(file)
    str = IO.popen(["marked", "-i", file.path]).read
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
      ext = File.extname(file_name)
      if ext == ".xmd" || ext == ".md"
        basename = File.basename(file_name, ext)
        wirte_to_temp_file("course", basename, ext, file.contents)
      end
    end
  end

  def save_lesson_index
    git = Git.open(course_base_dir)
    git.branch(version).gcommit.gtree.trees.each do |dir_name, dir|
      dir.files.each do |file_name, file|
        ext = File.extname(file_name)
        if ext == ".xmd" || ext == ".md"
          basename = File.basename(file_name, ext)
          wirte_to_temp_file(dir_name, basename, ext, file.contents)
        end
      end
    end
  end

  # {"course" => f_course, "lesson 1 => s"}
  def wirte_to_temp_file(key, file_name, ext, contents)
    @temp_file = {} if !@temp_file
    f = Tempfile.new([file_name, ext], temp_dir)
    f.write(contents)
    f.close
    @temp_file[key] = f
  end

end
