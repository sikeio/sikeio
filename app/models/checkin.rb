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
#  timestamps           :datetime
#

class Checkin < ActiveRecord::Base
  belongs_to :enrollment
  belongs_to :lesson

  validates :lesson_id, presence: true

  before_save do
    if self.github_repository.nil?
      self.github_repository = project_repo_url
    end
    if self.timestamps.nil?
      self.timestamps = Time.now
    end
  end

  after_commit do |checkin|
    PublishTopicJob.perform_later(checkin)
  end

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

  def github_repository_name
    return nil if github_repository.nil?
    URI.parse(github_repository).path[1..-1]
  end

  def project_repo_url
    return nil if lesson.project.nil?
    # <github-username>/besike-<course-name>-<project-name>
    lesson.project_repo_url_for(enrollment.user)
  end

  def discourse_poster
    @discourse_poster ||= Checkin::DiscoursePoster.new(self)
  end
end
