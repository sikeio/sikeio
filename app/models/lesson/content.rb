class Lesson::Content

  ASSETS_TAG = ["img", "video"]
  ASSET_BASE = "/courses/"

  attr_reader :course_name, :version, :lesson_name

  def initialize(course_name, lesson_name, version="master")
    @course_name = course_name
    @lesson_name = lesson_name
    @version = version
  end

  def html_page
    html_content = ""
    xml = xml_content
    xml.children.each do |node|
      if node.name != "exercise"
          html_content << node.to_xhtml
      else
        html_content << exercise_html(node)
      end
    end
    set_assets_src(html_content)
  end

  private

  def set_assets_src(content)
    xml = Nokogiri::HTML(content)
    ASSETS_TAG.each do |tag|
      xml.css(tag).each do |node|
        if !node["src"] =~ /^(http).*/
          node["src"] = asset_src(node["src"])
        end
      end
    end
    xml.css("body").children.to_xhtml
  end

  def asset_src(src)
    ASSET_BASE + course_name + "/" + lesson_name + "/" + src
  end

  def exercise_html(exercise_node)
    ol_content = ""
    first_step = true
    ol_tag_end = false
    exercise_node.css("step").each do |node|
      ol_content << exercise_step_html(node)
    end
    output =  <<-THERE
    <div class="exercise">
      #{exercise_title(exercise_node)}
      <ol class='steps'>
        #{ol_content}
      </ol>
      <div class="goal">
        <i class="fa falflag">Pass</i>
        <span>testPathDrawing</span>
      </div>

      <div class="completed">
        <i class="fa fa-check-circle"></i>
        Completed!
      </div>
    </div>
    THERE
  end

  def exercise_step_html(exercise_step_node)
    li_content = ""

    exercise_step_node.children.each do |node|
      if node.name != "screenshot"
      elsif node.name == "video"
          li_content << video_html(node)
      else
        li_content << screenshot_html(node)
      end
    end

    output = <<-THERE
      <li class="step">
        #{li_content}
      </li>
    THERE
  end

  def screenshot_html(screen_node)
    other_content = ""
    screen_node.children.each do |node|
      if node.name == "caption"
        other_content << "<h2>#{node.text}</h2>"
      elsif node.name == "video"
        other_content << video_html(node)
      else
        other_content << node.to_xhtml
      end
    end

    output = <<-THERE
      <div class="screenshot">
        <img src=#{screen_node["src"]}/>
        #{other_content}
      </div>
    THERE
  end

  def exercise_title(exercise_node)
    h1_text = exercise_node.css("h1")[0].text
    output = <<-THERE
    <h1>
      #{h1_text}
      <div class="indicator">
        <i class="fa fa-wrench"></i>
        Exercise
      </div>
    </h1>
    THERE
  end


  def xml_content
    f = Course::FileReader.new(course_name, version)
    result = f.read_file
    xml = Nokogiri::HTML(result)
    xml = xml.css("page[name=#{lesson_name}]")[0]
  end
end
