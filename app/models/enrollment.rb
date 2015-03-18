class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  has_many :check_outs

  after_initialize do |a|
    #a.course.current_version = a.version
    puts a.version
  end

  def next_uncompleted_lesson
    #得到尚未完成的第一个课程
    self.course.lessons.find do |lesson|
      !(CheckOut.check_out?(self, lesson))
    end
  end

  def completed_lessons
    self.course.lessons.select do |lesson|
      CheckOut.check_out(self, lesson) && self.is_released?(lesson)
    end
  end

  def all_completed?
    self.course.lessons.all do |lesson|
      CheckOut.check_out?(self, lesson)
    end
  end

  def released_lessons
    self.course.lessons.select do |lesson|
      self.is_released? lesson
    end
  end


  def uncompleted_lesson_day_left 
    lesson = course.next_lesson(self.next_uncompleted_lesson)
    next_lesson_start_day = course.release_day_of_lesson(lesson)
    
    next_lesson_start_day - day_from_start_time
  end

  private

  def is_released?(lesson)
    day = self.course.release_day_of_lesson(lesson)
    day_from_start_time >= day
  end

  def day_from_start_time
    today = Time.now.beginning_of_day.to_date
    course_start_time = self.start_time.beginnig_of_day.to_date
    (today - course_start_time).to_i + 1
  end

end
