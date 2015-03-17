require "rails_helper"

RSpec.describe Course, :type => :model do
=begin
  before(:each) do
    @user = FactoryGirl.create :user
  end
=end
  let(:test_lessson_sum) { 8 }
  let(:test_change_lessons_sum) { 9 }
  let(:test_lessons) do
    lessons = []
    test_lessson_sum.times do |n|
      lessons << Lesson.find_by_name("test_lesson_#{n + 1}")
    end
    lessons
  end
  let(:test_weeks_sum) { 2 }
  let(:test_weeks) do
    course_weeks = []
    day_week = test_lessson_sum / test_weeks_sum
    test_weeks_sum.times do |week|
      week_lessons = []
      day_week.times do |day|
        week_lessons << [Lesson.find_by_name("test_lesson_#{ (week) * day_week + (day + 1) }"), day + 1]
      end
      course_weeks << week_lessons
    end
    course_weeks
  end
  let(:test_week_titles) do
    titles = []
    test_weeks_sum.times do |n|
      titles << "test_title_#{n + 1}"
    end
    titles
  end


  let(:course) do
    course = Course.create(name: "test_course", current_version: "v1")
    course.load
    course
  end

  before(:each) do
    FactoryGirl.create_list(:test_lesson, 10)
  end

  describe "#repo_path" do
    it 'returns path to the cached repo' do
      expect(course.repo_path).to eq(Rails.root + course.name + "v1")
    end
  end

  describe  "#xml_file_path" do
    it 'returns the xml file path' do
      expect(course.xml_file_path).to eq(course.repo_path + (course.name + ".xml"))
    end
  end

  describe "#lessons" do
    it 'returns all the lessons of the course' do
      lessons = []
      expect(course.lessons).to eq(test_lessons)
    end
  end

  describe "#lessons_sum" do
    it 'returns the sum of this lessons' do
      expect(course.lessons_sum).to eq(test_lessson_sum)
    end
  end

  describe "#course_weeks" do
    it 'returns the lessons grouped in weeks ' do
      expect(course.course_weeks).to eq(test_weeks)
    end
  end

  describe "#course_week_titles" do
    it 'returns the titles of weeks' do
      expect(course.course_week_titles).to eq(test_week_titles)
    end
  end

  describe "#course_weeks_sum" do
    it 'returns the sum of weeks in this course' do
      expect(course.course_weeks_sum).to eq(test_weeks_sum)
    end
  end

  describe "version handling" do
    describe "#set version" do
      #¿ÉÒÔÌí¼Ó¸ü¶àtest
      it 'changes the version to the given' do
        course.current_version = "v2"
        expect(course.current_version).to eq("v2")
      end

      it 'change the lessons_sum to the given version' do
        course.current_version = "v2"
        expect(course.lessons_sum).to eq(test_change_lessons_sum)
      end
    end

    describe "#get version" do
      it 'returns the version being used' do
        expect(course.current_version).to eq("v1")
      end
    end
  end

  after(:all) do
    FactoryGirl.reload
  end


#-------------------------------------------------------------------
=begin
  let(:course) { Course.create(name: "ios", current_version: "v1") }
  describe "cour" do
    
  end



  describe  "content handling" do

    describe "#content" do
      it 'returns an object of Content' do
        expect(course.content).to be_a(Course::Content)
      end
    end

    describe 'Course::Content' do
      let(:content) { course.content }
      describe "#repo_path" do
        it 'returns the path to the cached repo ' do
          expect(content.repo_path).to eq(Rails.root + "ios/master")
        end
      end

      describe "#index_file_path" do
        it 'returns the file path' do
          expect(content.index_file_path).to eq(content.repo_path + "ios.xml")
        end
      end

      describe "#lessons" do
        let(:content_v1) { course.content("v1")}
        let(:master_lessons) {  }
        it 'returns the master version lessons' do
          expect(content.lessons).to 
          
        end

        it 'returns the v1 version lessons' do
          
        end

        
      end

    end
  end
=end
=begin
  describe "Update Course accroding to the given XML file" do

    it 'should create course if the given course is not exists' do
      xml_file_path = Rails.root + "spec/models/create-course.xml"
      expect { Course.update_lessons!(xml_file_path) }.to change{Course.count}.by(1)
    end

    #怎么写更好？？？？
    it 'should update lessons if the given course exists' do
      xml_file_path = Rails.root + "spec/models/update-lessons.xml"
      # 测试写的是增加lessons
      expect { Course.update_lessons!(xml_file_path) }.to change{Lesson.count}
    end

  end
  describe  "Release Lesson" do
    before(:each) do
      date = Date.today
      @day_week = date.cwday

      @order = @user.orders.first

      @order.course.lessons.each do |lesson|
        lesson.day = @day_week
        lesson.save
      end
    end

    it 'should change order if course is not finished and the time is the lesson release day' do

      @order.released_lesson_num = 1
      @order.save



      expect { 
        Course.release_lesson!
        @order.reload 
      }.to change{ @order.released_lesson_num }.by(1)

    end

    it 'should not change order if today is not the lesson release day' do
      @order.course.lessons.each do |lesson|
        lesson.day = @day_week + 1
        lesson.save
      end

      @order.released_lesson_num = 1
      @order.save

      expect { 
        Course.release_lesson!
        @order.reload
      }.to_not change{ @order.released_lesson_num }
    end

    it 'should not change order if course is finished' do
      @order.released_lesson_num = @order.course.lessons.size
      @order.save

      expect { 
       Course.release_lesson!
       @order.reload 
      }.to_not change{ @order.released_lesson_num }

    end

  end    
=end


end
