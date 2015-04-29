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
  validates :lesson_id, presence: true

  after_save :publish

  def self.checkin?(enroll, temp_lesson)
    return false unless (enroll && temp_lesson)
    enroll.checkins.any? do |checkin|
      temp_lesson.id == checkin.lesson_id
    end
  end

  def publish
    discourse_poster.publish
  end

  def published?
    !self.discourse_post_id.nil?
  end

  def lesson
    Lesson.find_by_id(self.lesson_id)
  end

  private

  def discourse_poster
    @discourse_poster ||= Checkin::DiscoursePoster.new(self)
  end
end
