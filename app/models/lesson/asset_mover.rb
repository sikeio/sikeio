class Lesson::AssetMover

  attr_reader :course_name, :lesson_name, :version, :des_dir, :repo_dir
  def initialize(course_name, lesson_name, version)
    @des_dir = Course::Utils::ASSET_DIR + course_name + lesson_name + version
    @repo_dir = Course::Utils::REPO_DIR + course_name
    @course_name = course_name
    @lesson_name = lesson_name
    @version = version
    FileUtils.mkdir_p(@des_dir)
  end

  def move_file
    if !asset_exist?(des_dir)
      git = Git.open(repo_dir)
      git.branch(version).gcommit.gtree.trees[lesson_name].files.each do |file_name, file|
        ext = File.extname(file_name)
        if ext != ".xmd" && ext != ".md"
          f = File.new(des_dir + file_name, "w")
          f.write(file.contents)
          f.close
        end
      end
    end
  end

  private

  def asset_exist?(des_dir)
    result = false
    Dir.chdir(des_dir) do
      result = (Dir.glob("*").length != 0)
    end
    result
  end

end
