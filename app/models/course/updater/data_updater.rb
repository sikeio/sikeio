class Course::Updater::DataUpdater

  attr_reader :course_name, :content, :current_commit_msg, :course

  def initialize(course, current_commit_msg)
    @course = course
    @course_name = course.name
    @current_commit_msg = current_commit_msg
    @content = Course::Content.new(course)
  end

  def update_course_and_lessons
    update_course_according_to_xml
    update_lessons_according_to_xml
  end

  private

  def update_course_according_to_xml
    course_info = content.course_info
    course_info[:current_commit] = current_commit_msg
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
