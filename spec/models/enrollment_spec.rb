# == Schema Information
#
# Table name: enrollments
#
#  id                        :integer          not null, primary key
#  user_id                   :integer          not null
#  course_id                 :integer          not null
#  version                   :string
#  start_time                :datetime
#  enroll_time               :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  token                     :string           not null
#  personal_info             :json
#  activated                 :boolean          default(FALSE)
#  has_sent_invitation_email :boolean          default(FALSE)
#  paid                      :boolean          default(FALSE)
#  buddy_name                :string
#

require 'rails_helper'

RSpec.describe Enrollment, type: :model do

=begin
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

  describe "#is_next_uncompleted_lesson?" do
    let(:lesson) { Lesson.find_by_name("test_lesson_1") }

    it 'returns true if the lesson is the next uncompleted lesson' do
      expect(@enrollment.is_next_uncompleted_lesson?(lesson)).to eq(true)
    end

    it 'returns false if the lesson is not the next uncompleted lesson' do
      check = Checkout.create(lesson_name: "test_lesson_1")
      @enrollment.checkouts << check

      expect(@enrollment.is_next_uncompleted_lesson?(lesson)).to eq(false)
      @enrollment.checkouts = []
    end
  end

  describe "#completed_lessons_num" do
    it 'returns the num of completed lessons' do
      check = Checkout.create(lesson_name: "test_lesson_1")
      @enrollment.checkouts << check

      expect(@enrollment.completed_lessons_num).to eq(1)
      @enrollment.checkouts = []
    end
  end

  describe "#all_completed?" do
    before(:each) do
      7.times do |n|
        @enrollment.checkouts << Checkout.create(lesson_name: "test_lesson_#{n + 1}")
      end
    end
    it 'returns false if not all lessons finished' do
      expect(@enrollment.all_completed?).to eq(false)
      @enrollment.checkouts = []
    end

    it 'returns true if all lessons in this course finished' do
      @enrollment.checkouts << Checkout.create(lesson_name: "test_lesson_8")
      expect(@enrollment.all_completed?).to eq(true)
      @enrollment.checkouts = []
    end
  end

  describe "#uncompleted_lesson_day_left" do
    before(:all) do
      start = (Time.now.beginning_of_day.to_date).to_time
      @enrollment.update(start_time: start)
    end

    it 'returns the day left for the current lesson' do
      expect(@enrollment.uncompleted_lesson_day_left).to eq(1)
    end
  end

  describe "#is_released?" do
    before(:all) do
      start = (Time.now.beginning_of_day.to_date).to_time
      @enrollment.update(start_time: start)
    end

    it 'returns true if the lesson is released' do
      lesson = Lesson.find_by_name("test_lesson_1")
      expect(@enrollment.is_released?(lesson)).to eq(true)
    end

    it 'returns false if the lesson is not released' do
      lesson = Lesson.find_by_name("test_lesson_2")
      expect(@enrollment.is_released?(lesson)).to eq(false)
    end
  end

  describe "#any_released?" do

    it 'returns true if has lesson released' do
      start = (Time.now.beginning_of_day.to_date).to_time
      @enrollment.update(start_time: start)

      expect(@enrollment.any_released?).to eq(true)
    end

    it 'returns false if has no lesson released' do
      start = (Time.now.beginning_of_day.to_date + 1).to_time
      @enrollment.update(start_time: start)

      expect(@enrollment.any_released?).to eq(false)
    end

  end

  describe "#is_completed?" do
    let(:lesson) { Lesson.find_by_name("test_lesson_1") }

    it 'returns false if the lesson is not completed' do
      expect(@enrollment.is_completed?(lesson)).to eq(false)
    end

    it 'returns true if the lesson is completed' do
      check = Checkout.create(lesson_name: "test_lesson_1")
      @enrollment.checkouts << check
      expect(@enrollment.is_completed?(lesson)).to eq(true)
      @enrollment.checkouts = []
    end
  end
=end
end
