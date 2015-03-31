class LessonsController < ApplicationController

  before_action :require_login

  def show
    course = Course.find_by_name(params[:course_name])
    @enrollment = course.enrollments.find_by(user_id: session[:user_id])
    course_version = @enrollment.version if @enrollment.version
    @lesson = course.course_lesson(params[:lesson_name])
    if Checkout.check_out?(@enrollment, @lesson)
      @checkout = @enrollment.checkouts.find_by(lesson_name: @lesson.name)
    end
    content = Lesson::Content.new(course.name, course_version, @lesson.name)
    @lesson_html = content.html_page
  end

end
