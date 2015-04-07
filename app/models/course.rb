# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string
#  desc       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Course < ActiveRecord::Base

  attr_reader :content_version

  has_many :enrollments, dependent: :restrict_with_exception

  has_many :lessons

  has_many :users, through: :enrollments

  validates :name, presence: true,
    format: {with: /\A[a-zA-Z0-9\-_]+\z/},
    uniqueness: true
  validates_uniqueness_of :permalink

  def to_param
    self.permalink
  end

  def schedule(version = self.current_version)
    Schedule.new(self, version)
  end
end
