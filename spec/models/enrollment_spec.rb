require 'rails_helper'

RSpec.describe Enrollment, type: :model do

  let(:course) do
    user = FactoryGirl.create :user
    temp = FactoryGirl.create :test_course
    temp.current_version = "v1"
    user.courses << temp
    temp
  end

  let(:enrollment) do
    temp = course.enrollments.first
    temp.update(version: "v1")
    temp
  end

  let(:course_lesson_sum) { 8 }

  describe "#current_lesson_info" do
    it 'returns the current lesson' do
      enrollment.update(current_lesson_num: 1)
      expect(enrollment.current_lesson_info).to eq(Lesson.find_by_name("test_lesson_1"))
    end
  end

  describe "#all_finished?" do
    it 'returns true if all lessons in this course finished' do
      enrollment.update(current_lesson_num: (course_lesson_sum + 1))
      expect(enrollment.all_finished?).to eq(true)
    end

    it 'returns false if not all lessons finished' do
      enrollment.update(current_lesson_num: 1)
      expect(enrollment.all_finished?).to eq(false)
    end
  end

  describe "#lesson_status" do
    before(:each) do
      enrollment.update(current_lesson_num: 8, start_time: (Time.now.to_date - 7))
    end
    it 'returns -1 if lesson is finished' do
      lesson = Lesson.find_by_name("test_lesson_1")
      expect(enrollment.lesson_status(lesson)).to eq(-1)
    end

    it 'returns 0 if the lesson is being done' do
      lesson = Lesson.find_by_name("test_lesson_6")
      
    end

    it 'returns 1 if the lesson is waiting for done' do
      
    end

    it 'returns 2 if the lesson is not open' do
      
    end
  end

  describe "#current_lesson_day_left" do
    pending
    it 'returns the day left for the current lesson' do
      
    end
  end

end
