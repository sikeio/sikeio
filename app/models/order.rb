class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

=begin
  def self.release_lesson!
    date = Date.today
    day_week = date.cwday

    Order.all.each do |order|
      unless all_released?(order)
        next_release_num = order.released_lesson_num + 1
        course = order.course

        temp_num = 0
        find_lesson = false
        course.weeks.each do |week|
          week_lesson_num = week.lessons.size
          if (next_release_num <= temp_num + week_lesson_num)
            next_release_lesson = week.lessons[next_release_num - temp_num - 1] 
            # puts "pre rel_num: #{order.released_lesson_num}"
            order.update!(released_lesson_num: next_release_num) if next_release_lesson.day === day_week
            # puts "after rel_num: #{order.released_lesson_num}"
            # puts "find released_lesson.day: #{next_release_lesson.day}"
            # puts "today: #{day_week}"
            break
          else
            temp_num += week_lesson_num
          end
        end
      end 
    end

  end

  private

  def self.all_released?(order)
    return order.released_lesson_num >= order.course.lessons.size
  end
=end
end
