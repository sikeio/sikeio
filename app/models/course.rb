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

  def xml_file_path
    return nil if !self.name
    default_version if !self.current_version
    xml_file = self.name + ".xml"
    xml_dir = Course::Utils::XML_REPO_DIR + self.name + self.current_version
    ensure_dir_exist(xml_dir)
    xml_dir + xml_file
  end

  def asset_dir
    return nil if !self.name
    dir = Course::Utils::ASSET_DIR + "courses" + self.name
    ensure_dir_exist(dir)
    dir
  end

  def xml_dir
    return nil if !self.name
    dir = Course::Utils::XML_REPO_DIR + self.name + self.current_version
    ensure_dir_exist(dir)
    dir
  end

  def temp_dir
    dir = Course::Utils::TEMP_DIR
    ensure_dir_exist(dir)
    dir
  end

  def repo_dir
    return nil if !self.name
    Course::Utils::XML_REPO_DIR + self.name + self.current_version
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

  private

  def ensure_dir_exist(dir)
    FileUtils.mkdir_p(dir) if !File.exist?(dir)
  end

=begin
  def title=(title)
    super(title)
    self.permalink = title.parameterize
  end
=end
end
