require "rails_helper"

RSpec.describe Course::Content do

=begin
  let(:test_weeks) do
    course_weeks = []
    day_week = 4
    2.times do |week|
      week_lessons = []
      day_week.times do |day|
        week_lessons << "test_lesson_#{ (week) * day_week + (day + 1) }"
      end
      course_weeks << week_lessons
    end
    course_weeks
  end
  let(:test_week_titles) do
    titles = []
    titles = ["test_title_1", "test_title_2"]
  end


  let(:course) do
    Course.create(name: "test_course", current_version: "v1")
  end
  let(:content) do
    Course::Content.new(course)
  end

  before(:all) do
    FactoryGirl.create_list(:test_lesson, 10)
  end

  describe "#lessons_info" do
    before(:each) do
      @result_lessons_info = [{"test_lesson_1" => {"title" => "title of lesson 1", "overview" => "Information about the lesson 1"}},
                              {"test_lesson_2" => {"title" => "title of lesson 2", "overview" => "Information about the lesson 2"}},
                              {"test_lesson_3" => {"title" => "title of lesson 3", "overview" => "Information about the lesson 3"}},
                              {"test_lesson_4" => {"title" => "title of lesson 4", "overview" => "Information about the lesson 4"}},
                              {"test_lesson_5" => {"title" => "title of lesson 5", "overview" => "Information about the lesson 5"}},
                              {"test_lesson_6" => {"title" => "title of lesson 6", "overview" => "Information about the lesson 6"}},
                              {"test_lesson_7" => {"title" => "title of lesson 7", "overview" => "Information about the lesson 7"}},
                              {"test_lesson_8" => {"title" => "title of lesson 8", "overview" => "Information about the lesson 8"}},
                             ]
    end
    it 'returns all the lessons of the course' do
      expect(content.lessons_info).to eq(@result_lessons_info)
    end
  end

  describe "#lessons_sum" do
    it 'returns the sum of this lessons' do
      expect(content.lessons_sum).to eq(8)
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
      expect(content.course_weeks_sum).to eq(2)
    end
  end
=end

end
