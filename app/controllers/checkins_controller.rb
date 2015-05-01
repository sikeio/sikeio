class CheckinsController < ApplicationController

  before_action :require_login

  def create
    enrollment = course.enrollments.find_by(user_id: session[:user_id])
    raise "course not exist or not enroll" if !enrollment
    checkin_info = checkin_params
    checkin_info[:enrollment_id] = enrollment.id
    checkin_info[:lesson_id] = lesson.id
    checkin = Checkin.new(checkin_info)

    if checkin.save
      render json: success_msg(checkin.lesson.bbs)
    else
      render_400 checkin.errors
    end
  end

  def show
    enrollment = course.enrollments.find_by(user_id: session[:user_id])
    raise "course not exist or not enroll" if !enrollment
    if !Checkin.checkin?(enrollment, lesson)
      @url_path = checkin_path(lesson)
      @html_method = :post
      @checkin = Checkin.new
    else
      @checkin = enrollment.checkins.find_by(lesson_id: @lesson.id)
      @url_path = checkin_update_path(@checkin)
      @html_method = :put
    end
  end

  def update
    checkin = Checkin.find(params[:id])
    begin
      checkin.update!(checkin_params)
      render json: success_msg(checkin.lesson.bbs)
    rescue
      render json: error_msg(checkin.errors.full_messages)
    end
  end

  private

  def lesson
    @lesson ||= Lesson.find_by_permalink(params[:id])
  end

  def course
    @coruse ||= lesson.course
  end

  def checkin_params
    params.require(:checkin).permit(:degree_of_difficulty, :github_repository, :problem, :time_cost)
  end

  def error_msg(msg)
    result = {}
    result[:success] = false
    if msg.blank?
      result[:message] = "系统错误,请稍后尝试~"
    else
      result[:message] = msg
    end
    result
  end

  def success_msg(redirect_url)
    result = {}
    result[:success] = true
    result[:url] = redirect_url
    result
  end
 end
