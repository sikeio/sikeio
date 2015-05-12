# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  name            :string
#  desc            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_version :string
#  repo_url        :string
#  title           :string
#  permalink       :string
#  current_commit  :string
#

require "rails_helper"

RSpec.describe Course, :type => :model do
=begin
  before(:each) do
    @user = FactoryGirl.create :user
  end
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
        week_lessons << Lesson.find_by_name("test_lesson_#{ (week) * day_week + (day + 1) }")
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
    Course.create(name: "test_course", current_version: "v1")
  end

  before(:each) do
    FactoryGirl.create_list(:test_lesson, 10)
  end

  describe "#lessons" do
    it 'returns all the lessons of the course' do
      expect(course.lessons).to eq(test_lessons)
    end
  end

  describe "#release_day_of_lesson" do
    it 'returns the lesson release day from start time' do
      #lesson = Lesson.find_by_name("test_lesson_1")
      lesson = Lesson.last
      puts lesson.name
      expect(course.release_day_of_lesson(lesson)).to eq(8)
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

  after(:each) do
    FactoryGirl.reload
  end
=end
end
