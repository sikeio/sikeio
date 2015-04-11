class Course::Updater::RepoUpdater

  attr_reader :url, :repo_dir_path

  def initialize(url, repo_dir)
    @url = url
    @repo_dir_path = repo_dir
  end

  def update_repo
    if repo_cloned?
      pull_clone
    else
      clone_repo
    end
  end

  def repo_cloned?
    File.exist?(repo_dir_path)
  end

  def pull_clone
    git = Git.open(repo_dir_path)
    git.pull
  end

  def clone_repo
    FileUtils::mkdir_p(repo_dir_path)
    Git.clone(url, repo_dir_path)
  end

end
