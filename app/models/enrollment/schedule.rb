class Enrollment::Schedule

  attr_reader :content, :course, :enrollment

  def self.memoize(*method_syms)
    for sym in method_syms
      module_eval <<-THERE
        alias_method :__#{sym}__, :#{sym}
        private :__#{sym}__
        def #{sym}(*args, &block)
          @__#{sym}__ ||= __#{sym}__(*args, &block)
        end
        THERE
    end
  end


  def initialize(enrollment)
    @content = Course::Content.new(enrollment.course, enrollment.version)
    @course = enrollment.course
    @enrollment = enrollment
  end

  def lessons
    content.lessons_info.map do |lesson_attr|
      course.lessons.find_by_name(lesson_attr[:name])
    end
  end
  memoize :lessons

  def lessons_sum
    content.lessons_info.size
  end
  memoize :lessons_sum

  def course_weeks
    content.course_weeks.map do |week|
      week.map { |lesson_name| course.lessons.find_by_name(lesson_name) }
    end
  end
  memoize :course_weeks

  def course_weeks_sum
    content.course_weeks.size
  end
  memoize :course_weeks_sum

  def next_lesson(lesson)
    result = nil
    if index = lessons.index(lesson)
      result = lessons[index + 1]
    end
    result
  end

  def pre_lesson(lesson)
    result = nil
    if index = lessons.index(lesson)
      if index != 0
        result = lessons[index - 1]
      end
    end
    result
  end

  def release_day_of_lesson(lesson)
    content.release_day_of_lesson[lesson.name]
  end

  def weeks_info
    content.weeks_info
  end
  memoize :weeks_info

  def all_completed?
    lessons.all? do |lesson|
      Checkout.check_out?(enrollment, lesson)
    end
  end

  def is_completed?(lesson)
    Checkout.check_out?(enrollment, lesson)
  end

  def is_released?(lesson)
    day = release_day_of_lesson(lesson)
    day_from_start_time >= day
  end

  def any_released?
    first_lesson = lessons.first
    is_released?(first_lesson)
  end

  def week_lesson_released?(week_num)
    return false if !any_released?
    (week_num - 1) * 7 < day_from_start_time
  end

  def completed_lessons_num
    enrollment.checkouts.count
  end

  def current_lesson
    lessons.find do |lesson|
      is_released?(lesson) && (!is_completed?(lesson))
    end
  end

  def current_lesson_day_left
    time = nil
    if current_lesson
      if !is_last_lesson?(current_lesson)
        lesson = next_lesson(current_lesson)
        next_lesson_start_day = release_day_of_lesson(lesson)

        time = next_lesson_start_day - day_from_start_time
      end
    end

    time
  end

  def is_last_lesson?(lesson)
    lessons.last == lesson
  end




  private

  def day_from_start_time
    today = Time.now.beginning_of_day.to_date
    course_start_time = enrollment.start_time.beginning_of_day.to_date
    (today - course_start_time).to_i + 1
  end

end
