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
#  free            :boolean         default: false
#

class Course < ActiveRecord::Base

  has_many :enrollments, dependent: :restrict_with_exception

  has_many :lessons

  has_many :users, through: :enrollments

  validates :name, presence: true,
    format: {with: /\A[a-zA-Z0-9\-_]+\z/},
    uniqueness: true
  validates_uniqueness_of :permalink

  after_initialize do |course|
    course.current_version = "master" if course.current_version.blank?
  end

  REPO_BASE = Rails.root + (ENV["COURSE_BUILD_PATH"] || raise("Must specify a COURSE_BUILD_PATH to build a course"))
  ASSETS_BASE = Rails.root + "public"

  def generate_qa_topics
    self.content.lessons_info.each { |info|
      lesson = self.lessons.find_by(name: info[:name])
      lesson.create_qa_topic
    }
  end

  def assets_dir
    ASSETS_BASE + "courses" + self.name
  end

  def repo_dir
    REPO_BASE + self.name + self.current_version
  end

  def xml_path
    repo_dir + "course.xml"
  end

  def xml_file_path
    xml_path
  end

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
    self.permalink = name.parameterize
    super(name)
  end

  def repo
    Course::Repo.new(self)
  end

  def compiler
    Course::Compiler.new(self)
  end

  def content
    Course::Content.new(self)
  end

  def compiled?
    File.exists?(xml_path)
  end

  def content_update
    Course::ContentUpdater.new(self).update
  end
end
