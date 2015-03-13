class Lesson < ActiveRecord::Base
  belongs_to :week

  #validates :name, uniqueness: { case_sensitive: false, scope: :course_id,
  #                               message: "should have uniq name per course" }
  validates :name, :week, presence: true 
end
