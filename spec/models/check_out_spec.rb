require 'rails_helper'

RSpec.describe CheckOut, type: :model do

  let(:course) do
    user = FactoryGirl.create :user
    temp = FactoryGirl.create :test_course
    temp.current_version = "v1"
    user.courses << temp
    temp
  end

  let(:checkout) do
    temp_check = FactoryGirl.create :check_out
    enrollment.check_outs << temp_check
    temp_check
  end

  let(:enrollment) do
    temp_enroll = course.enrollments.first
    temp_enroll.update(version: "v1")
    temp_check = FactoryGirl.create :check_out
    temp_enroll.check_outs << temp_check
    temp_enroll
  end

  let(:lesson_not_checked) do
    FactoryGirl.create :lesson_not_checked
  end

  let(:lesson_checked) do
    FactoryGirl.create :lesson_checked
  end

  describe ".check_out?" do
    it 'returns true if the lesson is checked out' do
      expect(CheckOut.check_out?(enrollment, lesson_checked)).to eq(true)
    end

    it 'returns false if the lesson is not checked out' do
      expect(CheckOut.check_out?(enrollment, lesson_not_checked)).to eq(false)
    end
  end

  describe "#lesson" do
    it 'returns lesson' do
      course
      expect(checkout.lesson).to eq(Lesson.find_by_name(checkout.lesson_name)) 
    end
  end

end
