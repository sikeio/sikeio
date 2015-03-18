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

  describe "#next_uncompleted_lesson" do
    it 'returns the current lesson waiting for being done' do
      expect(enrollment.next_uncompleted_lesson).to eq(Lesson.find_by_name("test_lesson_1"))
    end
  end

  describe  "#completed_lessons" do
    it 'returns the lessons that already finished' do
      check = CheckOut.create(lesson_name: "test_lesson_1")
      enrollment.check_outs << check
      temp = []
      temp << Lesson.find_by_name("test_lesson_1")

      expect(enrollment.completed_lessons).to eq(temp)
    end
  end

  describe "#uncompleted_lessons" do
    it 'returns the lessons that already released but not completed' do
      
    end
  end

  describe "#released_lessons" do
    it 'returns the lessons that already released' do
      
      
    end
  end

  describe "#all_completed?" do
    it 'returns true if all lessons in this course finished' do
      expect(enrollment.all_completed?).to eq(true)
    end

    it 'returns false if not all lessons finished' do
      expect(enrollment.all_completed?).to eq(false)
    end
  end

  describe "#uncompleted_lesson_day_left" do
    it 'returns the day left for the current lesson' do
      
    end
  end

end
