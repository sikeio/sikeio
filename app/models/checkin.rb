# == Schema Information
#
# Table name: checkins
#
#  id                   :integer          not null, primary key
#  enrollment_id        :integer
#  problem              :text
#  github_repository    :string
#  time_cost            :integer
#  degree_of_difficulty :integer
#  lesson_id            :integer
#  discourse_post_id    :integer
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
