class Course::FileRemover

  attr_reader :asset_path, :xml_repo_path
  def initialize(course_name)
    @asset_path = Course::Utils::ASSET_DIR + course_name
    @xml_repo_path = Course::Utils::XML_REPO_DIR + course_name
  end

  def remove_course_releated_file
    delete_all_file(asset_path)
    delete_all_file(xml_repo_path)
  end

  private

  def delete_all_file(dir)
    if File.exist?(dir)
      Dir.chdir(dir) do
        list = Dir.glob("*")
        puts list
        FileUtils.rm_rf(list)
      end
    end
  end

end
