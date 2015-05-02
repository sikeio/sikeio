# == Schema Information
#
# Table name: lessons
#
#  id                 :integer          not null, primary key
#  name               :string
#  title              :string
#  overview           :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  course_id          :integer
#  permalink          :string
#  bbs                :string
#  discourse_topic_id :integer
#  project            :string
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
end
