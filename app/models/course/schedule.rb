class Course::Schedule

  attr_reader :course, :version, :content

  def initialize(course, version)
    @course = course
    @version = version
    @content = Course::Content.new(course.name, version)
  end

  def lessons  #根据先后顺序排序好的
    lessons = []
    content.lessons_info.each do |lesson_name, other_attr|
      lessons << course.lessons.find_by_name(lesson_name)
    end
    lessons
  end

  def lesson_number(lesson)
    content.lesson_numbers[lesson.name]
  end

  def next_lesson(lesson)
    index = self.lessons.find_index { |var_lesson| lesson == var_lesson }
    self.lessons[index + 1]
  end

  def pre_lesson(lesson)
    index = self.lessons.find_index { |var_lesson| lesson == var_lesson }
    self.lessons[index - 1]
  end

  def lessons_sum
    content.lessons_sum
  end

  def course_lesson(lesson_permalink)
    lessons.find { |lesson| lesson.permalink == lesson_permalink }
  end

  def course_weeks #排序好的
    content.course_weeks.map do |one_week|
      one_week.map { |lesson_name|  course.lessons.find_by_name(lesson_name) }
    end
  end

  def course_week_titles
    content.course_week_titles
  end

  def course_weeks_sum
    content.course_weeks_sum
  end

  def release_day_of_lesson(lesson)
    content.release_day_of_lesson[lesson.name]
  end

end
