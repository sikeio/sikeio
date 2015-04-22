# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  name            :string
#  desc            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_version :string
#  repo_url        :string
#  title           :string
#  permalink       :string
#  current_commit  :string
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

  def self.by_param(id)
    self.find_by(permalink: id)
  end

  def self.by_param!(id)
    self.find_by!(permalink: id)
  end

  def to_param
    self.permalink
  end

  def schedule(version = "master")
    Course::Schedule.new(self, version)
  end

  def name=(name)
    super(name)
    self.permalink = name.parameterize
  end

=begin
  def title=(title)
    super(title)
    self.permalink = title.parameterize
  end
=end
end
