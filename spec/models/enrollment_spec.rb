require 'rails_helper'

RSpec.describe Enrollment, type: :model do

  before(:all) do
    FactoryGirl.create_list(:test_lesson, 10)
    user = FactoryGirl.create :user
    @course = FactoryGirl.create :test_course
    user.courses << @course
    @enrollment = user.enrollments.first
  end

  describe "#next_uncompleted_lesson" do
    it 'returns the current lesson waiting for being done' do
      expect(@enrollment.next_uncompleted_lesson).to eq(Lesson.find_by_name("test_lesson_1"))
    end
  end

  describe  "#completed_lessons" do
    after(:each) do
      @enrollment.checkouts = []
    end
    it 'returns the lessons that already finished' do
      check = Checkout.create(lesson_name: "test_lesson_1")
      @enrollment.checkouts << check
      temp = []
      temp << Lesson.find_by_name("test_lesson_1")

      expect(@enrollment.completed_lessons).to eq(temp)
    end
  end

  describe "#uncompleted_lessons" do
    before(:each) do
      start = (Time.now.beginning_of_day.to_date - 1).to_time
      @enrollment.update(start_time: start)
    end

    after(:each) do
      @enrollment.checkouts = []
    end

    it 'returns the lessons that already released but not completed' do
      check = Checkout.create(lesson_name: "test_lesson_1")
      @enrollment.checkouts << check
      temp = []
      temp << Lesson.find_by_name("test_lesson_2")

      expect(@enrollment.uncompleted_lessons).to eq(temp)
    end
  end

  describe "#released_lessons" do
    before(:each) do
      start = (Time.now.beginning_of_day.to_date - 1).to_time
      @enrollment.update(start_time: start)
    end

    it 'returns the lessons that already released' do
      temp = []
      temp << Lesson.find_by_name("test_lesson_1")
      temp << Lesson.find_by_name("test_lesson_2")

      expect(@enrollment.released_lessons).to eq(temp)
    end
  end

  describe "#unreleased_lessons" do
    before(:each) do
      start = (Time.now.beginning_of_day.to_date - 1).to_time
      @enrollment.update(start_time: start)
    end
    
    it 'returns the lessons that not released' do
      temp = []
      6.times do |n|
        temp << Lesson.find_by_name("test_lesson_#{n + 3}")
      end

      expect(@enrollment.unreleased_lessons).to eq(temp)
    end
    
  end

  describe "#all_completed?" do
    before(:each) do
      7.times do |n|
        @enrollment.checkouts << Checkout.create(lesson_name: "test_lesson_#{n + 1}")
      end
    end

    after(:each) do
      @enrollment.checkouts = []
    end

    it 'returns true if all lessons in this course finished' do
      @enrollment.checkouts << Checkout.create(lesson_name: "test_lesson_8")
      expect(@enrollment.all_completed?).to eq(true)
    end

    it 'returns false if not all lessons finished' do
      expect(@enrollment.all_completed?).to eq(false)
    end
  end

  describe "#uncompleted_lesson_day_left" do
    before(:each) do
      start = (Time.now.beginning_of_day.to_date).to_time
      @enrollment.update(start_time: start)
    end

    it 'returns the day left for the current lesson' do
      expect(@enrollment.uncompleted_lesson_day_left).to eq(1)
    end
  end

end
