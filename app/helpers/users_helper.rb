module UsersHelper

  def course_link(course)
    if current_user
      course_path(course)
    else
      root_path(course: course.permalink)
    end
  end

  def lesson_link(lesson)
    if current_user
      lesson_path(lesson.course, lesson)
    else
      root_path(course: lesson.course.permalink)
    end
  end

end
