class CheckinsController < ApplicationController
  layout "logined", except: [:info]

  before_action :require_login
  before_action :param_validate, only: [:create, :update]

  def create
    if !enrollment_valid?(enrollment)
      flash[:error] = nil
      raise "course not exist or not enroll"
    end

    checkin_info = checkin_params
    checkin_info[:enrollment_id] = enrollment.id
    checkin_info[:lesson_id] = lesson.id

    checkin = Checkin.new(checkin_info)

    if checkin.save
      mixpanel_track(checkin.enrollment.id, "Create Checkin")

      render json: success_msg(checkin.lesson.discourse_checkin_topic_url)
    else
      render_400 checkin.errors
    end
  end

  def show
    get_info
    if !enrollment_valid?(@enrollment)
      flash[:error] = nil
      raise "course not exist or not enroll"
    end
    if !Checkin.checkin?(@enrollment, @lesson)
      @url_path = checkin_path(@lesson)
      @html_method = :post
      @checkin = Checkin.new
    else
      @checkin = enrollment.checkins.find_by(lesson_id: @lesson.id)
      @url_path = checkin_update_path(@checkin)
      @html_method = :put
    end
  end

  def update
    begin
      checkin = current_user.checkins.find(params[:id].split('-').last)
      checkin.update!(checkin_params)
      render json: success_msg(checkin.lesson.discourse_checkin_topic_url)
    rescue
      if checkin
        render json: error_msg(checkin.errors.full_messages)
      else
        render json: error_msg("所要更新的打卡不存在~")
      end
    end
  end

  private

  def param_validate
    if params[:checkin][:time_cost].blank?
      render json: error_msg("请告诉我们您完成课程所用的时间~")
    elsif (false if Float(params[:checkin][:time_cost]) rescue true)
      render json: error_msg("请填写合法的时间值~")
    elsif params[:checkin][:degree_of_difficulty].blank?
      render json: error_msg("请告诉我们您认为课程难度如何~")
    end
  end

  def get_info
    enrollment
    lesson
    course
  end

  def enrollment
    @enrollment ||= current_user.enrollments.find_by(course_id: course.id)
  end

  def lesson
    @lesson ||= Lesson.find_by_permalink(params[:id])
  end

  def course
    @course ||= lesson.course
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
