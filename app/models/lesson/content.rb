class Lesson::Content

  attr_reader :course_name, :version, :lesson_name

  def initialize(course_name, version, lesson_name)
    @course_name = course_name
    @version = version
    @lesson_name = lesson_name
  end

  def html_page
    html_content = ""
    xml = xml_content
    puts xml
    xml.children.each do |node|
      if node.name != "exercise"
        html_content << node.to_xhtml
      else
        html_content << exercise_html(node)
      end
    end
    html_content
  end

  def exercise_html(exercise_node)
    ol_content = ""
    first_step = true
    ol_tag_end = false
    exercise_node.css("exercise-step").each do |node|
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
        if node.type == Nokogiri::XML::Node::TEXT_NODE && node.text.strip != ""
          li_content << "<p>#{node.text}</p>"
        elsif node.name == "code"
          li_content << "<pre>#{node.to_xhtml}</pre>"
        else
          li_content << node.to_xhtml
        end
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
    first = true
    screen_node.children.each do |node|
      if !first
        other_content << node.to_xhtml
      else
        first = false
      end
    end

    output = <<-THERE
      <div class="screenshot">
        #{screen_head(screen_node)}
        #{other_content}
      </div>
    THERE
  end

  def screen_head(node)
    src = "/" + course_name + "/" + lesson_name + "/" + node["src"]
    output = <<-THERE
      #{node.child.to_xhtml}
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
    git = Git.open(Course::Utils::XML_REPO_DIR + course_name)
    file = course_name + ".xml"
    xml = Nokogiri::HTML(git.show(version, file))
    xml = xml.css("page[name=#{lesson_name}]")[0]
  end
end
