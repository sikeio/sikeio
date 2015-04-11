class Course::Updater
  attr_reader :course, :course_repo_dir, :course_xml_repo_dir, :course_xml_file_path

  def initialize(course)
    @course = course
    @course_repo_dir = Course::Utils::REPO_DIR + course.name
    @course_xml_repo_dir = Course::Utils::XML_REPO_DIR + course.name + "master"
    @coures_asset_dir = Course::Utils::ASSET_DIR + course.name
    file_name = course.name + ".xml"
    @course_xml_file_path = @course_xml_repo_dir + file_name
  end

  def update
    remove_releated_file
    clone_file_to_repo
    data = md_parse
    write_to_xml_repo(data)
    update_database
  end

  def remove_releated_file
    Course::FileRemover.new(course.name).remove_course_releated_file
  end


  def clone_file_to_repo
    repo_updater = RepoUpdater.new(course.repo_url, course_repo_dir)
    repo_updater.update_repo
  end

  def md_parse
    parse = Course::MdParse.new(course_repo_dir)
    parse.result
  end

  def write_to_xml_repo(data)
    FileUtils.mkdir_p(course_xml_repo_dir)
    f = File.new(course_xml_file_path, "w")
    f.write(data)
    f.close
  end

  module Foo
  end

  def update_databse
    Course::XMLUpdater.new(course.name).update_course_and_lessons
  end
end
