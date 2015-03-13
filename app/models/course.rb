class Course < ActiveRecord::Base

  has_many :lessons,  -> { order 'day ASC'}, through: :weeks  
  has_many :weeks, -> { order 'num ASC' } ,dependent: :destroy
  has_many :orders # dependent: :destroy 需要吗？
  has_many :users, through: :orders

  validates :name ,presence: true

=begin
  def self.release_lesson!
    Order.release_lesson!
  end
=end

  def self.update_lessons!(xml_file_path)
    raise "Error: #{xml_file_path} does not exist" if !File.exist?(xml_file_path)
    #--get xml content ---
    f = File.open(xml_file_path)
    xml_doc = Nokogiri::XML(f)
    f.close

    #TO_DO 应该检查格式？

    #--parse xml and update DB--
    xml_doc.css('course').each do |course_node|

      #get course and lesson
      course_name = course_node["name"]
      unless course = Course.find_by_name(course_name)
        course = Course.create!(name: course_name) 
      end

      week_num = 0
      course_node.css('week').each do |week_node|
        week_num += 1
        unless week = course.weeks.find_by(num: week_num)
          week = Week.create(num: week_num)
          course.weeks << week
        end
        week.title = week_node["title"]
        week.save

        week_node.css('lesson').each do |lesson_node|
          overview_node = lesson_node.css('overview')

          #get all the info needed to update db  
          lesson_name = lesson_node["name"]
          lesson_title = lesson_node["title"]
          lesson_overview = overview_node.text

          #lessons conflict 
          lesson_day = week.lessons.exists?(day: lesson_day) ? nil : lesson_node["day"] 

          lesson_info = {
            name: lesson_name, 
            title: lesson_title, 
            overview: lesson_overview,
            day: lesson_day,
          }

          #create or update record
          lesson = week.lessons.exists?(name: lesson_name) ? lesson.update!(lesson_info) : week.lessons.create!(lesson_info)

        end
      end
    end
  end

  def include_user?(user)
    participants.include? user.id
  end

end

