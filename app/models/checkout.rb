class Checkout < ActiveRecord::Base
  belongs_to :enrollment

  def self.check_out?(enroll, lesson)
    return false unless (enroll && lesson)
    enroll.checkouts.any? do |checkout|
      lesson.name == checkout.lesson_name
    end
  end

  def lesson
    Lesson.find_by_name(self.lesson_name)
  end

end
