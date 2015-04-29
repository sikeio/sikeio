class CheckinsController < ApplicationController

  before_action :require_login

  def new
    course = Course.find_by_permalink(params[:course_permalink])
    enrollment = course.enrollments.find_by(user_id: session[:user_id])
    lesson = course.course_lesson(params[:lesson_permalink])

    checkin_info = checkin_params
    checkin_info[:enrollment_id] = enrollment.id
    checkin_info[:lesson_name] = lesson.name
    checkin = Checkin.new(checkin_info)
    result = {}
    if check.save
      render js: "window.location='#{course_path(enrollment.course)}'"
    else
      result[:success] = false
      result[:message] = check.errors.full_messages
      render json: result
    end
  end

  def update
    checkin = Checkin.find(params[:id])
    begin
      checkin.update!(checkout_params)
      render js: "window.location='#{course_path(checkin.enrollment.course)}'"
    rescue
      result[:success] = false
      result[:message] = check.errors.full_messages
      render json: result
    end
  end

  private

  def checkin_params
    params.require(:checkin).permit(:degree_of_difficulty, :github_repository, :solved_problem, :question, :time_cost)
  end
end
