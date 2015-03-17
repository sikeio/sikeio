require "rails_helper"

RSpec.describe Course::Content do

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
    Course.create(name: "test_course")
  end
  let(:content) do  
    Course::Content.new(course, "v1") 
  end

  before(:each) do
    FactoryGirl.create_list(:test_lesson, 10)
  end

  describe "#repo_path" do
    it 'returns path to the cached repo' do
      expect(content.repo_path).to eq(Rails.root + course.name + "v1")
    end
  end

  describe  "#xml_file_path" do
    it 'returns the xml file path' do
      expect(content.xml_file_path).to eq(content.repo_path + (course.name + ".xml"))
    end
  end

  describe "#lessons" do
    it 'returns all the lessons of the course' do
      lessons = []
      expect(content.lessons).to eq(test_lessons)
    end
  end

  describe "#lessons_sum" do
    it 'returns the sum of this lessons' do
      expect(content.lessons_sum).to eq(test_lessson_sum)
    end
  end

  describe "#course_weeks" do
    it 'returns the lessons grouped in weeks ' do
      expect(content.course_weeks).to eq(test_weeks)
    end
  end

  describe "#course_week_titles" do
    it 'returns the titles of weeks' do
      expect(content.course_week_titles).to eq(test_week_titles)
    end
  end

  describe "#course_weeks_sum" do
    it 'returns the sum of weeks in this course' do
      expect(content.course_weeks_sum).to eq(test_weeks_sum)
    end
  end

  describe "version handling" do
    describe "#set version" do
      #可以添加更多test
      it 'changes the version to the given' do
        content.version = "v2"
        expect(content.version).to eq("v2")
      end

      it 'change the lessons_sum to the given version' do
        content.version = "v2"
        expect(content.lessons_sum).to eq(test_change_lessons_sum)
      end
    end

    describe "#get version" do
      it 'returns the version being used' do
        expect(content.version).to eq("v1")
      end
    end
  end

  after(:all) do
    FactoryGirl.reload
  end

end
