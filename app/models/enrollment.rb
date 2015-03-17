class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  def current_lesson_info
    temp = self.current_lesson_num
    course = self.course
    course.current_version = self.version
    current_lesson = nil
    return current_lesson if temp <= 0 || temp >= course.lessons_sum
    course_weeks = course.course_weeks
    weeks_sum = course.course_weeks_sum

    weeks_sum.times do |num|
      week_lessons = course_weeks[num]
      if temp <= week_lessons.size
        current_lesson = week_lessons[temp - 1][0]
        break
      else
        temp -= week_lessons.size
      end
    end
    current_lesson
  end

  def all_finished?
    current_lesson_num = self.current_lesson_num
    course = self.course
    course.current_version = self.version
    current_lesson_num > course.lessons_sum
  end

  def released_lesson_num
    released_lesson_num = 0
    course = self.course
    course.current_version = self.version
    start_time = self.start_time.to_date
    start_day = start_time.cwday

    start_time = start_time + 8 - start_day if start_day != 1
    start_year = start_time.cwyear
    start_week = start_time.cweek

    today = Date.today
    today_year = today.cwyear
    today_week = today.cweek
    today_day = today.cwday

    #时间跨年
    weeks = (today_year - start_year) * 53 + today_week - start_week
    if(weeks >= 0)
      weeks_sum = course.course_weeks_sum
      if weeks >= weeks_sum
        released_lesson_num += course.lessons_sum
      else
        weeks.times do |n|
          released_lesson_num += 1 if course.course_weeks[weeks][n][1] <= day
        end
      end
    end
    released_lesson_num
    
  end

  def lesson_status(lesson)
    result = nil
    current_lesson_num = self.current_lesson_num
    released_num = released_lesson_num 
    course = self.course
    course.current_version = self.version
    
    unless course.has_lesson?(lesson)
      result = -2
    else
      lessons = course.lessons
      lessons.size.times do |n|
        if lessons[n] == lesson
          temp_num = n + 1
          if temp_num == current_lesson_num
            result = 0 #current
            break
          elsif temp_num < current_lesson_num
            result = -1#finished
            break
          elsif temp_num < released_num
            result = 1 # wait for being done
            break
          else
            result = 2 # no released
            break
          end
        end
      end
    end
    result
  end

  def current_lesson_day_left
    course = self.course
    course.current_version = self.version
    temp_num = self.current_lesson_num

    require_day = 0
    course.course_weeks_sum.times do |num|
      week_lessons = course.course_weeks[num]
      if temp_num <= week_lessons.size
        lesson_info = week_lessons[temp_num - 1]
        require_day += lesson_info[1]
        break
      else  
        temp_num -= week_lessons.size
        require_day += 7
      end
    end

    start_time = self.start_time.to_date
    start_day = start_time.cwday

    start_time = start_time + 8 - start_day if start_day != 1 
    require_time = start_time + require_day
    today = Date.today
    day_left = (require_time - today).to_i
  end

end
