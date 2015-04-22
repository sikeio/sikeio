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

  attr_reader :content_version, :xml_file_path, :asset_dir, :temp_dir, :repo_dir, :xml_dir

  has_many :enrollments, dependent: :restrict_with_exception

  has_many :lessons

  has_many :users, through: :enrollments

  validates :name, presence: true,
    format: {with: /\A[a-zA-Z0-9\-_]+\z/},
    uniqueness: true
  validates_uniqueness_of :permalink

  after_initialize do |course|
    xml_file = course.name + ".xml"
    course.current_version = "master" if course.current_version.blank?
    @xml_file_path = Course::Utils::XML_REPO_DIR + course.name + course.current_version + xml_file
    @asset_dir = Course::Utils::ASSET_DIR + "courses" + course.name
    @xml_dir = Course::Utils::XML_REPO_DIR + course.name + course.current_version
    @temp_dir = Course::Utils::TEMP_DIR
    @repo_dir = Course::Utils::REPO_DIR + course.name
    xml_dir = Course::Utils::XML_REPO_DIR + course.name + course.current_version
    FileUtils.mkdir_p(xml_dir) if !File.exist?(xml_dir)
    FileUtils.mkdir_p(@asset_dir) if !File.exist?(@asset_dir)
    FileUtils.mkdir_p(@temp_dir) if !File.exist?(@temp_dir)
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
