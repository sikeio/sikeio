class Lesson::Content

  attr_reader :course_name, :version, :lesson_name

  def initialize(course_name, version, lesson_name)
    @course_name = course_name
    @version = version
    @lesson_name = lesson_name
  end

  def html
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
    content = ""
    first_step = true
    ol_tag_end = false
    exercise_node.children.each do |node|
      if node.name != "exercise-step"
        content << node.to_xhtml
      else
        if first_step
          out = <<-THERE
          <ol class="steps">
          THERE
          content << out
          first_step = false
        end
        content << exercise_step_html(node)
        if node.next_sibling == nil || node.next_sibling.name != "exercise-step"
          if !ol_tag_end
            content << "</ol>"
            ol_tag_end = true
          end
        end
      end
    end
    output =  <<-THERE
    <div class="exercise">
    #{content}
    </div>
    THERE
  end

  def exercise_step_html(exercise_step_node)
    content = ""
    new_content_div = true
    more_than_one_screenshot = false
    exercise_step_node.children.each do |node|
      if node.name != "screenshot"
        if new_content_div
          out = <<-THERE
           <div class="content">
          THERE
          content << out
          new_content_div = false
        end
        content << node.to_xhtml
      else
        if new_content_div
          out = <<-THERE
            <div class="content">
          THERE
          content << out
        end
        content << screenshot_html(node, more_than_one_screenshot)
        more_than_one_screenshot = true
        content << "</div>"
        new_content_div = true
      end
      if node.next_sibling == nil && !new_content_div
        content << "</div>"
      end
    end

    output = <<-THERE
    <li class="steps">
    #{content}
    </li>
    THERE
  end

  def screenshot_html(screenshot_node, next_tag)
    content = ""
    screenshot_node.children.each do |node|
      content << node.to_xhtml
    end

    if next_tag
      next_p = next_arrow
    else
      next_p = ""
    end

    output = <<-THERE
    <div class="guide">
    #{next_p}
    #{content}
    </div>
    THERE
  end

  def next_arrow
    output = <<-THERE
        <p class='next'>
          <i class="fa fa-angle-double-down"></i>
        </p>
    THERE
  end

  def xml_content
    git = Git.open(Course::Utils::XML_REPO_DIR + course_name)
    file = course_name + ".xml"
    xml = Nokogiri::HTML(git.show(version, file))
    xml = xml.css("page[name=#{lesson_name}]")[0]
  end
end
