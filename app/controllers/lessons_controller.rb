class LessonsController < ApplicationController

  before_action :require_login

  def show
    course = Course.find_by_permalink(params[:course_permalink])
    @enrollment = course.enrollments.find_by(user_id: session[:user_id])
    schedule = @enrollment.schedule
    @lesson = schedule.course_lesson(params[:lesson_permalink])
    if Checkout.check_out?(@enrollment, @lesson)
      @checkout = @enrollment.checkouts.find_by(lesson_name: @lesson.name)
    end
    version = @enrollment.version ? @enrollment.version : "master"
    content = Lesson::Content.new(course.name, version, @lesson.name)
    @lesson_html = content.html_page
  end
end
