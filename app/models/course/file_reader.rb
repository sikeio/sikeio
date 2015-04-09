class Course::FileReader

  def self.read_file(name, version)
    raise "pass the file name" if !name
    version = "master" if !version
    dir = Course::Utils::XML_REPO_DIR + name + version
    FileUtils::mkdir_p(dir)
    file = name + ".xml"
    if File.exist?(dir + file)
      f = File.open(dir + file)
      result = f.read
      f.close
    else
      xmd_dir = Course::Utils::REPO_DIR + name
      if File.exist?(xmd_dir)
        parse = Course::MdParse.new(xmd_dir)
        f = File.new(dir + file, "w")
        f.write(parse.result)
      end

    end
  end
end
