class CoursesController < ApplicationController

  before_action :require_login, except: [:info]
#  before_action :require_course_exists,except:[:list,:create_enroll]
#  before_action :require_take_part_in,only:[:show]
  before_action :ensure_trailing_slash, only:[:show]

  def index
    @courses = Course.all
    @enrollments = current_user.enrollments.activated
    if @enrollments.length == 1
      redirect_to course_path(@enrollments[0].course)
      return
    end
  end

  def info
    # TODO: should show only live courses
    @course_name = course.name

    if !["ios","nodejs"].include?(@course_name)
      render_404("No such course: #{@course_name}")
      return
    end
  end

  def show
    @enrollment = current_user.enrollments.find_by(course: course)

    if @enrollment.nil?
      flash[:error] = "您没有报名这个课程"
      redirect_to info_course_path(course)
      return
    end

    if !@enrollment.activated
      flash[:error] = "您尚未激活该课程"
      redirect_to info_course_path(course)
      return
    end
    @enrollment.update!(last_visit_time: Time.now)
    @send_day = Time.now.beginning_of_day.to_f * 1000 # convert to milliseconds for js
    #render '_show'
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
