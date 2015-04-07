class Course::XMLUpdater

  def self.update_course_and_lessons(course_name, version)
    update_course_according_to_xml(course_name, version)
    update_lessons_according_to_xml(course_name, version)
  end

  def self.update_course_according_to_xml(course_name, version)
    content = Course::Content.new(course_name, version)
    course_info = content.course_info
    if course = Course.find_by_name(course_name)
      course.update(course_info)
    else
      course = Course.new(name: course_name)
      course.save
      course.update(course_info)
    end
  end

  def self.update_lessons_according_to_xml(course_name, version)
    content = Course::Content.new(course_name, version)
    course = Course.find_by_name(course_name)
    lessons_info = content.lessons_info
    lessons_info.each do |lesson_name, other_attr|
      if lesson = Lesson.find_by_name(lesson_name)
        lesson.update(other_attr)
      else
        lesson = Lesson.create(name: lesson_name,course_id: course.id)
        lesson.update(other_attr)
      end
    end
  end
end
