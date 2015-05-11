# == Schema Information
#
# Table name: lessons
#
#  id                    :integer          not null, primary key
#  name                  :string
#  title                 :string
#  overview              :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  course_id             :integer
#  permalink             :string
#  bbs                   :string
#  discourse_topic_id    :integer
#  project               :string
#  discourse_qa_topic_id :integer
#

class Lesson < ActiveRecord::Base

  #validates :name, uniqueness: { case_sensitive: false, scope: :course_id,
  #                               message: "should have uniq name per course" }
  validates :name,  presence: true
  validates_uniqueness_of :name, scope: :course_id
  validates_uniqueness_of :permalink, scope: :course_id
  belongs_to :course

  def content
    @content ||= Content.new(self.course, self)
  end

  def to_param
    self.permalink
  end

  def name=(name)
    self.permalink = name.parameterize
    super(name)
  end

  def project_repo_name_for(user)
    "#{user.github_username}/besike-#{self.course.name}-#{self.project}"
  end

  def project_repo_url_for(user)
    "https://github.com/#{project_repo_name_for(user)}"
  end

  def discourse_qa_topic_url
    "http://#{ENV["DISCOURSE_HOST"]}/t/#{self.discourse_qa_topic_id}"
  end

  def create_qa_topic
    return if self.discourse_qa_topic_id
    lesson_index = self.bbs.match(/lesson-(\d+)/)[1]
    title = "Lesson #{lesson_index} FAQ - #{self.title}"
    raw = "Lesson #{lesson_index} 问题帖~~小伙伴们有什么问题请在这里提问~~"
    category = "#{self.course.name.capitalize} 训练营"
    api = Checkin::DiscourseAPI.new
    result = api.create_topic(title, raw, category)

    self.update_attribute :discourse_qa_topic_id, result['topic_id']
  end
end
