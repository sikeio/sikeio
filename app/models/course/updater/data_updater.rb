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
    course_info[:name] = course_name

    create_or_update(Course, course_info)
  end

  def update_lessons_according_to_xml
    lessons_info = content.lessons_info
    extra_lessons_info = content.extra_lessons_info

    lessons = [lessons_info, extra_lessons_info].flatten
    lessons.each do |info|
      info[:course_id] = course.id

      old_name = info.delete(:old_name)
      if old_name.blank?
        create_or_update(Lesson, info)
      else
        lesson_rename(old_name, info)
      end

    end
  end

  def create_or_update(klass, attributes)
    if !attributes[:course_id].blank?
      klass_instance = klass.find_or_initialize_by(name: attributes[:name], course_id: attributes[:course_id])
    else
      klass_instance = klass.find_or_initialize_by(name: attributes[:name])
    end

    klass_instance.update!(attributes)
    klass_instance
  end

  def lesson_rename(old_name, attributes)
    lesson = Lesson.find_by_name(old_name)
    if lesson
      lesson.update(attributes)
    else
      raise "Lesson Change Name Error: the lesson #{old_name} is not exists"
    end
  end

end

