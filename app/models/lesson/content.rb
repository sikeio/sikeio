class Lesson::Content

  attr_reader :course_name, :version, :lesson_name

  def initialize(temp_name, temp_version, lesson_name)
    @course_name = temp_name
    @version = temp_version
    @lesson_name = lesson_name
  end

  def html_page
    html_content = ""
    xml = xml_content
    puts xml
    xml.children.each do |node|
      if node.name != "exercise"
        if node.name == "video"
          html_content << video_html(node)
        else
          html_content << node.to_xhtml
        end
      else
        html_content << exercise_html(node)
      end
    end
    html_content
  end

  def video_html(node)
    src = "/" + course_name + "/" + lesson_name + "/" + version + "/" + node["src"]
    output = <<-THERE
    <video  autoplay="true" loop="true" controls="true" src=#{src}></video>
    THERE
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
        #{img(screen_node)}
        #{other_content}
      </div>
    THERE
  end

  def img(node)
    src = "/" + course_name + "/" + lesson_name + "/" + version + "/" + node["src"]
    output = <<-THERE
      <img src=#{src}>
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
