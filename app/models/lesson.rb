# == Schema Information
#
# Table name: lessons
#
#  id         :integer          not null, primary key
#  name       :string
#  title      :string
#  overview   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lesson < ActiveRecord::Base

  #validates :name, uniqueness: { case_sensitive: false, scope: :course_id,
  #                               message: "should have uniq name per course" }
  validates :name,  presence: true
  validates_uniqueness_of :name, scope: :course_id
  validates_uniqueness_of :permalink, scope: :course_id
  belongs_to :course

  def content
    @content ||= Content.new
  end

  def to_param
    self.permalink
  end

end
