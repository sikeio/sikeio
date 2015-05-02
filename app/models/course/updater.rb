require 'forwardable'

class Course::Updater

  extend Forwardable

  attr_reader :course

  def_delegators :@course, :repo_dir, :assets_dir, :xml_file_path

  def initialize(course)
    @course = course
  end

  def update
    cleanup

    course.repo.update

    xml = course.compiler.course_xml
    write_to_xml_repo(xml)

    update_database

    course.update_attributes current_commit: course.repo.current_commit

    sync_assets
  end

  def sync_assets
    puts "making assets avaiable for: #{course.name}"
    from_dir = repo_dir.to_s
    # /public/courses/:course_name/:lesson_name
    to_dir = assets_dir.to_s
    system "mkdir", "-p", to_dir
    # The trailing "/" indicates to rsync that we want to copy the content to the
    # destination without creating an additional sub-directory.
    cmd = ["rsync", "-Pa", from_dir.to_s + "/", to_dir.to_s]
    p cmd
    system *cmd
  end

  def cleanup
    # don't really need to do any cleanup.
  end

  def write_to_xml_repo(data)
    f = File.new(xml_file_path, "w")
    f.write(data)
    f.close
  end

  def update_database
    Course::Updater::DataUpdater.new(course).update
  end
end
