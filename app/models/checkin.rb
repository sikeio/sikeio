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

class Checkin < ActiveRecord::Base
  belongs_to :enrollment

  validates :github_repository, format: {with: /(https:\/\/)?github\.com\//, message: "github的格式不正确~"}
  validates :lesson_name, presence: true

  def self.checkin?(enroll, lesson)
    return false unless (enroll && lesson)
    enroll.checkins.any? do |checkin|
      lesson.id == checkin.lesson_id
    end
  end

  def lesson
    Lesson.find_by(id: self.lesson_id)
  end
end
