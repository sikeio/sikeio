class Course::Updater::RepoUpdater

  attr_reader :url, :repo_dir_path

  def initialize(course)
    @url = course.repo_url
    @repo_dir_path = course.repo_dir
  end

  def update_repo
    ensure_repo_path

    if repo_cloned?
      pull_clone
    else
      clone_repo
    end
  end

  private

  def repo_cloned?
    File.exist?(repo_dir_path + ".git")
  end

  def pull_clone
    git "fetch"
    git "reset", "--hard", "origin/master"
  end

  def clone_repo
    git "clone", url, "."
  end

  def ensure_repo_path
    FileUtils::mkdir_p(repo_dir_path)
  end

  def git(*args)
    p ["git", *args]
    Dir.chdir(repo_dir_path) do
      system "git", *args
    end
  end

end
