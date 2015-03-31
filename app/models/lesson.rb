class Lesson < ActiveRecord::Base

  #validates :name, uniqueness: { case_sensitive: false, scope: :course_id,
  #                               message: "should have uniq name per course" }
  validates :name,  presence: true 

  def content
    @content ||= Content.new
  end

  def lesson_git_path
    
  end

end
