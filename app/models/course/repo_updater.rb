class Course::RepoUpdater

  attr_reader :course

  def initialize(temp_course)
    @course = temp_course
  end

  def update_repo
    puts repo_dir_path
    if repo_cloned?
      pull_clone
    else
      clone_repo
    end
  end

  def repo_cloned?
    File.exist?(repo_dir_path)
  end

  def repo_dir_path
    Rails.root + "repo" + course.name
  end

  def pull_clone
    git = Git.open(repo_dir_path)
    git.pull
  end

  def clone_repo
    FileUtils::mkdir_p(repo_dir_path)
    Git.clone(course.repo_url, repo_dir_path)
  end

end
