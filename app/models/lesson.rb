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
  include EventLogging

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

  def position
    course.content.position_of_lesson(self.name)
  end

  def name=(name)
    self.permalink = name.parameterize
    super(name)
  end

  def project_repo_name_for(user)
    "#{user.github_username}/sike-#{self.course.name}-#{self.project}"
  end

  def project_repo_url_for(user)
    "https://github.com/#{project_repo_name_for(user)}"
  end

  def discourse_checkin_topic_url
    "http://#{ENV["DISCOURSE_HOST"]}/t/#{self.discourse_topic_id}"
  end

  def discourse_qa_topic_url
    "http://#{ENV["DISCOURSE_HOST"]}/t/#{self.discourse_qa_topic_id}"
  end

  def create_checkin_topic
    return if self.discourse_topic_id
    title = "Lesson #{self.position} 打卡 - #{self.title}"
    raw = "课程打卡在这里"
    category = "#{self.course.name} FAQ"

    api = Checkin::DiscourseAPI.new
    result = api.create_topic(title, raw, category)

    self.update(discourse_topic_id: result['topic_id'])
  end

  def create_qa_topic
    return if self.discourse_qa_topic_id
    title = "Lesson #{self.position} FAQ - #{self.title}"
    raw = "课程有问题在这里提问。"
    category = "#{self.course.name} FAQ"
    api = Checkin::DiscourseAPI.new
    result = api.create_topic(title, raw, category)

    self.update_attribute :discourse_qa_topic_id, result['topic_id']
  rescue RestClient::Exception => e
    p e.response.headers
    puts e.response.to_str
    log_event("discourse.checkin-fail", {
      lesson_id: self.id,
      body: e.response.to_str.force_encoding("UTF-8")
    })
    raise e
  end
end
