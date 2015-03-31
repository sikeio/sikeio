class Lesson::Content

  EXERCISE_TITLE = "h2"

  SPECIAL_BLOCK_TAG = {
                        "exercise" => {"class" => "exercise" },
                        "screenshot" => {"class" => "guide" },
                        "tip" => {"class" => "tip" },
                        "code" => {"class" => "code"}
                     }
  SPECIAL_INLINE_TAG = {
                         "video" => { "info_needed" => ["src"], "tag" => "video","options" => {"class" => "video"} },
                         "exercise-test" => { "info_needed" => ["name"], "tag" =>"a", "options" => {"class" => "exercise_text" } }
                       }
  def haha
    f = File.open(Rails.root + "lesson.xml")
    xml = Nokogiri::HTML(f)
    f.close

    document = xml.document
    parse_normal_block(xml, document)
    pre_parse_special_block_tag(xml, document)
    parse_exercise_block(xml, document)
    parse_screenshot_block(xml, document)
    parse_tip_block(xml, document)
    add_tail_section(xml, document)
    add_head_style(xml, document)
    f = File.new(Rails.root + "hahaha.html", "w+")
    f.write(xml.to_xhtml)
    f.close
  end

  def initialize(course_name, version, lesson_name)
    @course_name = course_name
    @version = version
    @lesson_name = lesson_name
  end

  def repo_path
    Rails.root + @course_name
  end

  def html_page
    git = Git.open(repo_path)
    file = @lesson_name + ".xml"
    xml = Nokogiri::HTML(git.show(@version, file))

    document = xml.document
    parse_normal_block(xml, document)
    pre_parse_special_block_tag(xml, document)
    parse_exercise_block(xml, document)
    parse_screenshot_block(xml, document)
    parse_tip_block(xml, document)
    xml.to_xhtml
  end


  def parse_tip_block(xml, document)
    xml.css("tip").each do |tip_node|
      p = Nokogiri::XML::Node.new("p", document)
      tip_node.child.children.each do |child_node|
        p.add_child(child_node)
      end
      tip_node.child.add_child(p)
      tip_node.replace(tip_node.child)
    end
  end

  def parse_normal_block(xml, document)
    normal_node = normal_div(document)
    xml.css("body").children.each do |child|
      unless child.name == "exercise" || child.name == "tip" || child.name == "h2"
        normal_node.add_child(child.dup)
        child.remove
      else
        if normal_node.element_children.size > 0
          child.add_previous_sibling(normal_node)
          normal_node = normal_div(document)
        end
        if child.name == "h2"
          normal_node.add_child(child.dup)
          child.remove
        end
      end
    end
    if normal_node.element_children.size > 0
      xml.css("body")[0].add_child(normal_node)
    end
  end

  def normal_div(document)
    div = Nokogiri::XML::Node.new("div", document)
    div["class"] = "normal"
    div
  end

  def pre_parse_special_block_tag(xml, document)
    SPECIAL_BLOCK_TAG.each do |tag, options|
      xml.css(tag).each do |node|
        new_node_tag = (tag == "code") ? "pre" : "div"
        new_node = Nokogiri::XML::Node.new(new_node_tag, document)
        options.each do |key, value|
          new_node[key] = value
        end
        if tag == "code"
          new_node.add_child(node.dup)
          node.replace(new_node)
        else
          clone_nodeset_as_children(node.children, new_node)
          node.add_child(new_node)
        end
      end
    end
  end

  def clone_nodeset_as_children(nodeset, parent)
    nodeset.each do |node|
      parent.add_child(node.dup)
      node.remove
    end
  end

  def parse_exercise_block(xml, document)
    parse_exercise_head(xml, document)
    parse_exercise_step(xml, document)
    xml.css("exercise").each do |exercise_node|
      ol_node = exercise_ol_node(document)
      exercise_steps = exercise_node.css("exercise-step").sort
      first_exercise_step = exercise_steps[0]
      first_exercise_step.add_previous_sibling(ol_node)

      exercise_steps.each do |exercise_step_node|
        ol_node.add_child(exercise_step_node.child.dup)
        exercise_step_node.remove
      end
      exercise_node.replace(exercise_node.child)
    end
  end


  def next_node(document)
    p = Nokogiri::XML::Node.new("p", document)
    p["class"] = "next"
    i = Nokogiri::XML::Node.new("i", document)
    i["class"] = "fa fa-angle-double-down"

    p.add_child(i)
    p
  end

  def parse_img_option(img, screenshot_node)
      info = screenshot_node["src"].split(/\?/)
      src = info[0]
      if info.length >= 2
        option_info = info[1]
        options = option_info.split(/ +/)
        options.each do |opt|
          opt_single = opt.split(/=/)
          img[opt_single[0]] = opt_single[1]
        end
      end
      img["src"] = "/" + @course_name + "/" + @lesson_name + "/" + src
  end

  def parse_screenshot_block(xml, document)
    parent_node = nil
    xml.css("screenshot").each do |screenshot_node|
      #add next ico if the screenshot more than one in a step
      img = img_node(document)
      parse_img_option(img, screenshot_node)
      screenshot_node.child.prepend_child(img)
      if parent_node == screenshot_node.parent.parent #first parent is content_div.   content_div's parent is li
        screenshot_node.add_previous_sibling(next_node(document))
      end
      parent_node = screenshot_node.parent.parent
      screenshot_node.replace(screenshot_node.child)
    end
  end



  def img_node(document)
    img = Nokogiri::XML::Node.new("img", document)
  end

  def add_content_div_with_screenshot(exercise_step_node, document)
    child = exercise_step_node.child
    next_child = nil
    content_div = content_div_node(document)

    while child
      next_child = child.next_sibling
      if child.name != "screenshot"
        content_div.add_child(child.dup)
        child.remove if next_child != nil
      else
        content_div.add_child(child.dup)
        child.replace(content_div)
        content_div = content_div_node(document)
      end
      unless next_child
        if content_div.element_children.size > 0
          child.replace(content_div)
        end
      end
      child = next_child
    end
  end

  def add_content_div_without_screenshot(exercise_step_node, document)
      content_div = content_div_node(document)
      child = exercise_step_node.child
      next_child = nil
      pre_child = nil

      while child
        next_child = child.next_sibling
        content_div.add_child(child.dup)
        child.remove if next_child
        pre_child = child
        child = next_child
      end
      pre_child.replace(content_div) if pre_child
  end

  def add_content_div(exercise_step_node, document)
    if exercise_step_node.css("screenshot").size > 0
      add_content_div_with_screenshot(exercise_step_node, document)
    else
      add_content_div_without_screenshot(exercise_step_node, document)
    end


  end

  def parse_exercise_step(xml, document)
    xml.css("exercise-step").each do |exercise_step_node|
      if exercise_step_node.child.text?
        h3 = exercise_step_h3_node(document)
        h3.content = exercise_step_node.child.text.strip
        exercise_step_node.child.replace(h3)
      end
      li_node = exercise_step_li_node(document)

      add_content_div(exercise_step_node, document)

      clone_nodeset_as_children(exercise_step_node.children, li_node)
      exercise_step_node.add_child(li_node)
    end
  end

  def content_div_node(document)
    div = Nokogiri::XML::Node.new("div", document)
    div["class"] = "content"
    div
  end

  def exercise_ol_node(document)
    ol_node = Nokogiri::XML::Node.new("ol", document)
    ol_node["class"] = "steps"
    ol_node
  end

  def exercise_step_h3_node(document)
    Nokogiri::XML::Node.new("h3", document)
  end

  def exercise_step_li_node(document)
    li_node = Nokogiri::XML::Node.new("li", document)
    li_node["class"] = "step"
    li_node
  end


  def parse_exercise_head(xml, document)
    xml.css("exercise").each do |exercise_block|
      exercise_div = exercise_block.first_element_child
      exercise_title = exercise_div.first_element_child
      if exercise_title.name == EXERCISE_TITLE
        exercise_title.add_child(exercise_ico_node(document))
      end
    end
  end

  def exercise_ico_node(document)
    div = Nokogiri::XML::Node.new("div", document)
    div["class"] = "indicator"

    i = Nokogiri::XML::Node.new("i", document)
    i["class"] = "fa fa-wrench"

    text = Nokogiri::XML::Text.new("Exercise", document)

    div.add_child(i)
    div.add_child(text)

    div
  end
end
