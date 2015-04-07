class CoursesController < ApplicationController

  #before_action :require_login,only:[:show, :start]
#  before_action :require_course_exists,except:[:list,:create_enroll]
#  before_action :require_take_part_in,only:[:show]

  def info
    course
  end

  def show
    @enrollment = course.enrollments.find_by(user: current_user)
    if !@enrollment.activated
      flash[:error] = "您尚未激活该课程"
      redirect_to :root
      return
    end
    @send_day = Date.today.day
    #render '_show'
  end

  def pay
    @course = Course.find params[:id]
  end

  def invite
    @course = Course.find params[:id]
    @user = User.take
  end

  # 待定  should use before_action to controller login or not
  def start
    user = current_user
    course = Course.find params[:id]

=begin
    unless user
      store_location payment_course_url(course)
      return redirect_to login_path
    end
=end

    if user.courses.include? course.id
      redirect_to course_path(course)
    else
      update_record
      redirect_to course_path(course)
    end
  end


  def send_course_preview
    #TODO
  end

  def get_user_status
    result = {}
    result["has_logged_in"] = login?
    if login?
      result["has_enrolled"] = Course.find_by_id(params[:course_id]).include_user?(current_user)
    end
    render json:result
  end

  private

  def course
    @course ||= Course.find_by!(permalink: params[:id])
  end


  def require_take_part_in
    @course = Course.find params[:id]
    unless @course.users.find current_user.id
      flash[:error] = "尚未参加这门课程~"
      redirect_to root_path
    end
  end

=begin
  def require_course_exists
    course = Course.find_by_id(params[:id]) || Course.find_by_id(params[:course_id])
    redirect_to root_path unless course
  end
=end

  def require_course_exists(course_id)
    course = Course.find course_id
    redirect_to root_path unless course
  end

  def update_record
    user = current_user
    course = Course.find params[:id]
    user.courses = course
  end


end
