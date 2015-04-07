class CheckoutsController < ApplicationController

  before_action :require_login

  def new
    course = Course.find_by_permalink(params[:course_permalink])
    enrollment = course.enrollments.find_by(user_id: session[:user_id])
    lesson = course.course_lesson(params[:lesson_permalink])

    check_out_info = checkout_params
    check_out_info[:enrollment_id] = enrollment.id
    check_out_info[:lesson_name] = lesson.name
    check = Checkout.new(check_out_info)
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
    checkout = Checkout.find(params[:id])
    begin
      checkout.update!(checkout_params)
      render js: "window.location='#{course_path(checkout.enrollment.course)}'"
    rescue
      result[:success] = false
      result[:message] = check.errors.full_messages
      render json: result
    end
  end

  private

  def checkout_params
    params.require(:checkout).permit(:degree_of_difficulty, :github_repository, :solved_problem, :question, :time_cost)
  end
end
