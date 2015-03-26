class Lesson::Content

  SPECIAL_BLOCK_TAG = {
                        "exercise-step" => {"class" => "exercise-step" },
                        "exercise" => {"class" => "exercise" },
                        "screenshot" => {"class" => "screenshot" },
                        "exercise-text" => {"class" => "exercise-text" },
                        "tip" => {"class" => "tip" }
                     }
  SPECIAL_INLINE_TAG = {
                         "video" => { "info_needed" => ["src"], "tag" => "video","options" => {"class" => "video"} },
                         "exercise-test" => { "info_needed" => ["name"], "tag" =>"a", "options" => {"class" => "exercise_text" } }
                       }

  def haha
    f = File.open(Rails.root + "lesson.xml")
    xml = Nokogiri::HTML(f)
    f.close

    parse_special_block_tag(xml)
    parse_special_inline_tag(xml)
    f = File.new(Rails.root + "hahaha", "w+")     
    f.write(xml.to_s)
    f.close

  end

  def parse(xml)
  end

  def parse_special_inline_tag(xml)
    document = xml.document
    SPECIAL_INLINE_TAG.each do |tag, info|
      options = info["options"]
      new_inline_tag = info["tag"]
      info_needed = info["info_needed"]

      xml.css(tag).each do |node|
        new_inline_node = Nokogiri::XML::Node.new(new_inline_tag, document)
        info_needed.each do |key|
          options[key] = node[key]
        end
        options.each do |key, value|
          new_inline_node[key] = value
        end
        node.children.each { |child_node| new_div.add_child(child_node.dup) }
        node.replace(new_inline_node)
      end
    end
  end

  def parse_special_block_tag(xml)
    document = xml.document
    SPECIAL_BLOCK_TAG.each do |tag, options|
      xml.css(tag).each do |node|
        new_div = Nokogiri::XML::Node.new("div", document)
        options["src"] = node["src"] if tag == "screenshot"
        options.each do |key, value|
          new_div[key] = value
        end
        node.children.each { |child_node| new_div.add_child(child_node.dup) }
        node.replace(new_div)
      end
    end
  end
=begin
  def parse_lesson_xml(xml)
    xml.children.each do |node|
      if SPECIAL_TAG[node.name]
      new_node = parse_special_node(exercise_node, exercise_node.name, SPECIAL_TAG["exercise"])
      exercise_node.replace(new_node)
    end
    end

    xml
  end
=end
=begin
  def parse_special_node(special_node, tag, options)
    document = special_node.document
    special_div = Nokogiri::XML::Node.new("div", document)
    options.each do |key, value|
      special_div[key] = value
    end

    special_node.children.each do |node|
      div_child_node = nil
      if SPECIAL_TAG[node.name]
        next_options = SPECIAL_TAG[node.name]
        div_child_node = parse_special_node(node, node.name, next_options)
      else
        div_child_node = node.dup 
      end
      special_div.add_child(div_child_node)
    end
    special_div
  end



  #return a new node
  def parse_exercise(exercise_node)
    document = exercise_node.document
    exercise_div = Nokogiri::XML::Node.new("div", document)

    exercise_node.children.each do |node|
      div_child_node = nil
      SPECIAL_TAG.each do |tag| 
        div_child_node = parse_exercise_step(node) if node.matches?(tag)
      end
      div_child_node = node.dup if div_child_node == nil
      exercise_div.add_child(div_child_node)
    end
    exercise_div
  end

  #return a new node
  def parse_exercise_step(exercise_step_node)
    document = exercise_step_node.document
    exercise_step_div = Nokogiri::XML::Node.new("div", document)

    exercise_step_node.children.each do |node|
      div_child_node = nil
      if node.matches?("screenshot")
        div_child_node = parse_screenshot(node)
      else
        div_child_node = node.dup
      end
      exercise_step_div.add_child(div_child_node)
    end
    exercise_step_div
  end

  def parse_screenshot(screenshot_node)
    document = screenshot_node.document
    screenshot_div = Nokogiri::XML::Node.new("div", document)
    screenshot_div["class"] = "screenshot"

    screenshot_node.children.each do |node|
      screenshot_div.add_child(node.dup)
    end
    screenshot_div
  end
=end
end
