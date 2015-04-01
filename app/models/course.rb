class Course < ActiveRecord::Base

  DEFAULT_VERSION = "v1"

  has_many :enrollments , dependent: :destroy
  has_many :users, through: :enrollments

  validates :name ,presence: true

  attr_reader :current_version

  after_initialize do |course|
    course.current_version = DEFAULT_VERSION unless course.current_version
  end



  def lessons  #根据先后顺序排序好的
    lessons = []
    content.lessons_info.each do |lesson_info|
      lesson_info.each_key do |lesson_name|
        lessons << Lesson.find_by_name(lesson_name)
      end
    end
    lessons
  end

  def next_lesson(lesson)
    index = self.lessons.find_index { |var_lesson| lesson == var_lesson }
    self.lessons[index + 1]
  end

  def pre_lesson(lesson)
    index = self.lessons.find_index { |var_lesson| lesson == var_lesson }
    self.lessons[index - 1]
  end

  def lessons_sum
    content.lessons_sum
  end

  def course_lesson(lesson_name)
    lessons.find { |lesson| lesson.name = lesson_name }
  end

  def course_weeks #排序好的
    content.course_weeks.map do |one_week|
      one_week.map { |lesson_name|  Lesson.find_by_name(lesson_name) }
    end
  end

  def course_week_titles
    content.course_week_titles
  end

  def course_weeks_sum
    content.course_weeks_sum
  end

  def current_version=(new_version)
    if new_version && @current_version != new_version
      @current_version = new_version
      @content = nil
    end
  end

  def release_day_of_lesson(lesson)
    content.release_day_of_lesson[lesson.name]
  end

  def update_repo
    puts repo_dir_path
    if self.repo_cloned?
      pull_clone
    else
      clone_repo
    end
  end

  def repo_cloned?
    File.exist?(repo_dir_path)
  end

  def repo_dir_path
    Rails.root + "repo" + self.name
  end

  def pull_clone
    git = Git.open(repo_dir_path)
    git.pull
  end

  def clone_repo
    FileUtils::mkdir_p(repo_dir_path)
    Git.clone(repo_url, repo_dir_path)
  end


  private

  def content
    @content ||= Content.new(self)
  end

  #def self.update_lessons!(xml_file_path)
  #end
=begin
  def self.update_lessons!(xml_file_path)
    raise "Error: #{xml_file_path} does not exist" if !File.exist?(xml_file_path)
    #--get xml content ---
    f = File.open(xml_file_path)
    xml_doc = Nokogiri::XML(f)
    f.close


    #--parse xml and update DB--
    xml_doc.css('course').each do |course_node|

      #get course and lesson
      course_name = course_node["name"]
      unless Course.find_by_name(course_name)
        Course.create!(name: course_name)
      end

      course_node.css('week').each do |week_node|
        week_node.css('lesson').each do |lesson_node|
          overview_node = lesson_node.css('overview')

          #get all the info needed to update db
          lesson_name = lesson_node["name"]
          lesson_title = lesson_node["title"]
          lesson_overview = overview_node.text

          lesson_info = {
            name: lesson_name,
            title: lesson_title,
            overview: lesson_overview,
          }

          #create or update record
          (lesson = Lesson.find_by(name: lesson_name)) ? lesson.update!(lesson_info) : Lesson.create!(lesson_info)
        end
      end
    end
  end
=end
end

