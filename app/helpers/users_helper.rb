module UsersHelper

  def course_link(course)
    if current_user
      course_path(course)
    else
      info_course_path(course)
    end
  end

  def lesson_link(lesson)
    if current_user
      lesson_path(lesson.course, lesson)
    else
      info_course_path(lesson.course)
    end
  end

end