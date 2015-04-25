require 'forwardable'

class Course::ResourceRemover

  extend Forwardable

  attr_reader :asset_path, :xml_dir

  def_delegators :@course, :asset_dir, :xml_dir

  def initialize(course)
    @course = course
  end

  def remove_course_releated_file
    delete_all_file(asset_dir)
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
