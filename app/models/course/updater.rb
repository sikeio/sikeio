class Course::Updater
  attr_reader :course, :course_repo_dir, :course_xml_repo_dir, :course_xml_file_path, :new_version, :file_name

  def initialize(course, version)
    @new_version = version
    @course = course
    @course_repo_dir = Course::Utils::REPO_DIR + course.name
    @course_xml_repo_dir = Course::Utils::XML_REPO_DIR + course.name
    @file_name = course.name + ".xml"
    @course_xml_file_path = @course_xml_repo_dir + @file_name
  end

  def update
    clone_file_to_repo
    data = md_parse
    write_to_xml_repo(data)
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
    git = init_or_get_git(course_xml_repo_dir)
    f = File.new(course_xml_file_path, "w")
    f.write(data)
    f.close
    commit(git, file_name, new_version)
  end

  private
  def init_or_get_git(dir)
    git = nil
    if File.exist?(dir + ".git")
      git = Git.open(dir)
    else
      git = git_init(dir)
    end
    git
  end

  def git_init(dir)
    git = Git.init(dir.to_s)
    #to have HEAD point that should be used for g.status
    FileUtils.touch(dir + "README")
    git.add("README")
    git.commit("First Commit")
    git
  end

  def commit(git, name, version)
    #TODO
    #解决 changed 的问题
    if !(git.status.changed == {} && git.status.untracked == {})
      puts git.status.changed
      puts git.status.untracked
      git.add(name)
      git.commit(version)
      git.add_tag(version)
    end
  end
end
