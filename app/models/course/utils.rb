module Course::Utils
  REPO_DIR = Rails.root + (ENV["COURSE_BUILD_PATH"] || raise("Must specify a COURSE_BUILD_PATH to build a course"))
  XML_REPO_DIR = REPO_DIR + "__xml_repo"
  TEMP_DIR = REPO_DIR + "__temp"
  ASSET_DIR = Rails.root + "public"
end
