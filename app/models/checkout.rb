class Checkout < ActiveRecord::Base
  belongs_to :enrollment

  validates :github_repository, format: {with: /(https:\/\/)?github\.com\//, message: "github的格式不正确~"}
  validates :lesson_name, presence: true

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
