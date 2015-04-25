require 'forwardable'

class Course::Updater

  extend Forwardable

  attr_reader :course

  def_delegators :@course, :repo_dir, :asset_dir, :xml_file_path

  def initialize(course)
    @course = course
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
    from_dir = repo_dir
    # /public/courses/:course_name/:lesson_name
    to_dir = asset_dir
    system "mkdir", "-p", (Course::Utils::ASSET_DIR + "courses").to_s
    # The trailing "/" indicates to rsync that we want to copy the content to the
    # destination without creating an additional sub-directory.
    cmd = ["rsync", "-Pa", from_dir.to_s + "/", to_dir.to_s]
    p cmd
    system *cmd
  end

  def remove_releated_file
    Course::ResourceRemover.new(course).remove_course_releated_file
  end


  def clone_file_to_repo
    repo_updater = RepoUpdater.new(course)
    repo_updater.update_repo
  end

  def md_parse
    parse = Course::MdParse.new(course)
    parse.result
  end

  def write_to_xml_repo(data)
    f = File.new(xml_file_path, "w")
    f.write(data)
    f.close
  end

  def update_database(current_commit_msg)
    Course::Updater::DataUpdater.new(course, current_commit_msg).update_course_and_lessons
  end
end
