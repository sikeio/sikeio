class Course::Updater
  attr_reader :course, :course_repo_dir, :course_xml_repo_dir, :course_xml_file_path

  def initialize(course)
    @course = course
    @course_repo_dir = Course::Utils::REPO_DIR + course.name
    @course_xml_repo_dir = Course::Utils::XML_REPO_DIR + course.name + "master"
    file_name = course.name + ".xml"
    @course_xml_file_path = @course_xml_repo_dir + file_name
  end

  def update
    clone_file_to_repo
    data = md_parse
    write_to_xml_repo(data)
    update_databse
  end

  def clone_file_to_repo
    repo_updater = Course::RepoUpdater.new(course, course_repo_dir)
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

  def update_databse
    Course::XMLUpdater.new(course_name).update_course_and_lessons
  end
end