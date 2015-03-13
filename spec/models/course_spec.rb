require "rails_helper"

RSpec.describe Course, :type => :model do

  before(:each) do
    @user = FactoryGirl.create :user
  end

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

=begin
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
