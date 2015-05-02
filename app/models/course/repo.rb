class Course::Repo
  include EventLogging

  attr_reader :url, :repo_dir, :course

  def initialize(course)
    @course = course
    @url = course.repo_url
    @repo_dir = course.repo_dir
  end

  def update
    ensure_repo_path

    if repo_cloned?
      pull_clone
    else
      clone_repo
    end
  end

  def current_commit
    Dir.chdir(repo_dir) do
      return `git log -n 1`.strip
    end
  end

  private

  def repo_cloned?
    File.exist?(repo_dir + ".git")
  end

  def pull_clone
    log_event("course.repo-update",event_data)
    git "fetch"
    git "reset", "--hard", "origin/master"
  end

  def clone_repo
    log_event("course.repo-clone",event_data)
    git "clone", url, "."
  end

  def ensure_repo_path
    FileUtils::mkdir_p(repo_dir)
  end

  def git(*args)
    Dir.chdir(repo_dir) do
      system "git", *args
    end
  end

  def event_data
    {
      url: url,
      course_id: course.id
    }
  end

end
