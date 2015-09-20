require 'forwardable'
class Course::Compiler

  extend Forwardable

  WEEK_HEADER = "h2"
  COURSE_TITLE_HEADER = "h1"

  def_delegators :@course, :repo_dir

  def initialize(course, version = nil)
    raise "repo does not exist" if !File.exist?(course.repo_dir)
    @course = course
  end

  # @return {Array<String>} Return name of directories that has an index document
  def list_of_pages
    directories = Dir[repo_dir+"*"].select { |path|
      if File.directory?(path)
        %w(md xmd).any? { |ext|
          (Pathname.new(path) + "index.#{ext}").exist?
        }
      end
    }

    # just want relative path names
    directories.map { |dir| File.basename(dir) }
  end

  # @return {Nokogiri::XML} DOM of course index.
  def dom_for_index
    @dom_for_index ||= dom_for("")
  end

  # Translates dir/index.{md,xmd} to DOM, relative to repo dir.
  # @param {String} dir Name of a directory from which to read an index document.
  # @return {Nokogiri::XML} DOM of a page index.
  def dom_for(dir,lang=nil)
    dir = repo_dir + dir

    %w(md xmd).each do |ext|
      file = (dir + "index.#{ext}").to_s

      # add language extension
      if !lang.nil?
        file = file + ".#{lang}"

      end

      puts "read dom: #{file}"

      if File.exists?(file)
        case ext
        when "xmd"
          dom = compile_xmd(file)
        when "md"
          dom = compile_md(file)
        end

        return dom
      end
    end

    raise "Cannot find index{.md,.xmd} file for: #{dir}"
  end

  def course_xml
    xml = <<-THERE
    <course name="#{course_title}">
      #{overview_xml}
      #{index_xml}
      #{pages_xml}
    </course>
    THERE

    xml
  end

  def course_title
    puts "find course title"
    @course_title ||= dom_for_index.css(COURSE_TITLE_HEADER)[0].text
  end

  def page_names
    Dir[repo_dir].select {}
  end

  def overview_xml
    puts "overview_xml"
    node = dom_for_index.css(COURSE_TITLE_HEADER)[0].next_sibling
    course_overview = nil
    puts node.to_xhtml
    while node
      if node.name == WEEK_HEADER
        break
      end
      if node.name == "overview"
        course_overview = node.to_xhtml
        break
      end
    end
    course_overview
  end

  def index_xml
    puts "index_xml"
    <<-THERE
    <index>
      #{weeks_xml}
    </index>
    THERE
  end

  def has_week_defined?
    !dom_for_index.css("> #{WEEK_HEADER}").blank?
  end

  def weeks_xml
    weeks = ""
    xml = dom_for_index
    nodes_in_week = nil
    node = nil
    if has_week_defined?
      node = xml.css("> #{WEEK_HEADER}")[0]
    else
      nodes_in_week = ""
      node = xml.css("> lesson")[0]
    end
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
        <lesson day="#{node["day"]}" name="#{node["name"]}" old-name="#{node["old-name"]}" project="#{node["project"]}">
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
    pages = []
    list_of_pages.each do |page_name|
      puts "compiling #{page_name}"
      dom = dom_for(page_name)
      xml = <<-THERE
<page name="#{page_name}">
  #{dom.children.to_xhtml}
</page>
THERE

      pages.push xml

      # try to find translation file
      dom = dom_for(page_name,"cn")
      if !dom.nil?
        puts "compile cn version"
        xml = <<-THERE
<cnpage name="#{page_name}">
  #{dom.children.to_xhtml}
</cnpage>
THERE
        pages.push xml
      end


    end

    pages.join "\n"
  end

  def compile_xmd(path)
    str = IO.popen(["xmd", path]).read
    Nokogiri::HTML(str).css("body")[0].child
  end

  def compile_md(path)
    str = IO.popen(["marked", "-i", path]).read
    Nokogiri::HTML(str).css("body")[0]
  end

end
