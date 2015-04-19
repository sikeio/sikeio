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
    remove_releated_file
    clone_file_to_repo
    result = md_parse
    write_to_xml_repo(result[:xml])
    update_database(result[:current_commit_msg])

    sync_assets
  end

  private

  def sync_assets
    puts "making assets avaiable for: #{course.name}"
    from_dir = course_repo_dir
    to_dir = Course::Utils::ASSET_DIR + "courses" + course.name
    system "mkdir", "-p", (Course::Utils::ASSET_DIR + "courses").to_s
    cmd = ["rsync", "-Pa", from_dir.to_s + "/", to_dir.to_s]
    p cmd
    system *cmd
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
    {:xml => parse.result, :current_commit_msg => parse.current_commit_msg}
  end

  def write_to_xml_repo(data)
    FileUtils.mkdir_p(course_xml_repo_dir)
    f = File.new(course_xml_file_path, "w")
    f.write(data)
    f.close
  end

  def update_database(current_commit_msg)
    Course::Updater::XMLUpdater.new(course.name, current_commit_msg).update_course_and_lessons
  end
end
