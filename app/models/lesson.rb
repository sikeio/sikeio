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

  def content
    @content ||= Content.new
  end

  def lesson_git_path

  end

end
