class Course::MdParse

  WEEK_HEADER = "h2"
  COURSE_TITLE_HEADER = "h1"

  attr_reader :temp_dir, :repo_dir, :temp_files, :gcommit

  def initialize(course)
    raise "repo does not exist" if !File.exist?(course.repo_dir)
    @temp_dir = course.temp_dir
    @repo_dir = course.repo_dir
    version = course.current_version
    @gcommit = Git.open(repo_dir).branch(version).gcommit
  end


  def result
    {
      xml: output_xml,
      current_commit_msg: current_commit_msg
    }
  end

  private

  def output_xml
    copy_files_to_temp_dir
    course =<<-THERE
    <course name="#{course_title}">
      #{index_xml}
      #{pages_xml}
    </course>
    THERE
    clear_temp_dir
    course
  end

  def current_commit_msg
    message = gcommit.message
    sha = gcommit.sha
    message + ": " + sha
  end

  def course_title
    @course_title ||= course_index_dom.css(COURSE_TITLE_HEADER)[0].text
  end

  def lesson_names
    @lesson_names ||= course_index_dom.css("lesson").map {
      |node|
      name = node["name"]
      if name.blank?
        puts node
        raise "<lesson> is missing name attribute"
      end
      name
    }
  end

  def course_index_dom
    file = temp_files["course"]
    compile(file)
  end

  def clear_temp_dir
    temp_files.each_value { |f| f.unlink }
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

  def pages_xml
    pages =""
    temp_files.each_pair do |dir_name, file|
      if dir_name != "course"
        dom = compile(file)
        page = <<-THERE
      <page name="#{dir_name}">
        #{dom.children.to_xhtml}
      </page>
        THERE
        pages << page
      end
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

  def copy_files_to_temp_dir
    copy_course_index_md
    copy_extra_md
  end

  def copy_course_index_md
    file = gcommit.gtree.files["index.xmd"]
    write_to_temp_file("course", "index", "xmd", file.contents)
  end

  def copy_extra_md
    gcommit.gtree.trees.each do |dir_name, dir|
      file = dir["index.xmd"] || dir["index.md"]
      file_name = dir.key(file)
      ext = File.extname(file_name)
      write_to_temp_file(dir_name, ext, file.contents)
    end
  end

  def write_to_temp_file(key, ext, contents)
    @temp_files = {} if !@temp_files
    f = Tempfile.new(["temp", ext], temp_dir)
    f.write(contents)
    f.close
    @temp_files[key] = f
  end

end
