class Course::FileReader

  attr_reader :name, :version, :dir, :xmd_dir, :file, :asset_dir

  def initialize(course_name, course_version = "master")
    raise "pass the file name" if !course_name
    @name = course_name
    @version = course_version
    @dir = Course::Utils::XML_REPO_DIR + course_name + course_version
    @xmd_dir = Course::Utils::REPO_DIR + course_name
    @file = course_name + ".xml"
  end

  def read_file
    result = nil
    if File.exist?(dir + file)
      result = read_xml_file
    else
      if File.exist?(xmd_dir)
        parse_file
        result = read_xml_file
      end
    end
    result
  end

  private

  def read_xml_file
    f = File.open(dir + file)
    result = f.read
    f.close
    result
  end

  def parse_file
    parse = Course::MdParse.new(xmd_dir)
    f = File.new(dir + file, "w")
    f.write(parse.result)
    f.close
  end
end
