class Course::XMLUpdater

  attr_reader :course_name, :version, :content

  def initialize(course_name, version)
    raise "No course_name or version passed in" if !(course_name && version)
    @course_name = course_name
    @version = version
    @content = Course::Content.new(course_name, version)
  end

  def update_course_and_lessons
    course = update_course_according_to_xml
    update_lessons_according_to_xml(course)
  end

  private

  def update_course_according_to_xml
    course = nil
    course_info = content.course_info
    create_or_update(Course, course_name, course_info)
  end

  def update_lessons_according_to_xml(course)
    lessons_info = content.lessons_info
    lessons_info.each do |lesson_name, other_attr|
      other_attr[:course_id] = course.id
      create_or_update(Lesson, lesson_name, other_attr)
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
