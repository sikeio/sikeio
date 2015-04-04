# == Schema Information
#
# Table name: checkouts
#
#  id                   :integer          not null, primary key
#  enrollment_id        :integer
#  lesson_name          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  question             :text
#  solved_problem       :text
#  github_repository    :string
#  degree_of_difficulty :integer
#  time_cost            :integer
#

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
