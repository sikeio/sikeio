class Course::ResourceRemover

  attr_reader :asset_path, :xml_dir
  def initialize(course)
    @asset_path = course.asset_dir
    @xml_dir = course.xml_dir
  end

  def remove_course_releated_file
    delete_all_file(asset_path)
    delete_all_file(xml_dir)
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
