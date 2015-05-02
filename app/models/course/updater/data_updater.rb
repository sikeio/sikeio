class Course::Updater::DataUpdater

  attr_reader :course_name, :content, :course

  def initialize(course)
    @course = course
    @course_name = course.name
    @content = course.content
  end

  def update
    update_course_according_to_xml
    update_lessons_according_to_xml
  end

  private

  def update_course_according_to_xml
    course_info = content.course_info
    create_or_update(Course, course_name, course_info)
  end

  def update_lessons_according_to_xml
    lessons_info = content.lessons_info
    extra_lessons_info = content.extra_lessons_info

    lessons = [lessons_info, extra_lessons_info].flatten
    lessons.each do |info|
      info[:course_id] = course.id
      create_or_update(Lesson, info[:name], info)
    end
  end

  def create_or_update(klass, name_for_finding, attr_info_to_set)
    klass_instance = klass.find_by_name(name_for_finding)
    if klass_instance
      klass_instance.update(attr_info_to_set)
    else
      attr_info_to_set[:name] = name_for_finding
      klass_instance = klass.new(attr_info_to_set)
      klass_instance.save
    end
    klass_instance
  end
end
