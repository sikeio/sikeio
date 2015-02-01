class CoursesController < ApplicationController

  before_action :require_login,only:[:show]
  before_action :require_course_exists,except:[:list,:create_enroll]
  before_action :require_take_part_in,only:[:show]
  protect_from_forgery except: :create_enroll


  def create_enroll
    result = {}
    user = User.new(params.permit(:email,:name))
    if user.save
      result['success'] = true
    else
      result['success'] = false
      result['msg'] = user.errors.full_messages
    end

    render json: result
    if result['success'] == true
      UserMailer.welcome_email(user).deliver_later! wait: (30 + rand(30)).minutes
    end
  end

  #list every courses for user to visit payment page
  def list
    @courses = Course.all
  end

  def show
    @course = Course.find params[:id]
  end

  def payment
    @course = Course.find params[:id]
    @display_top = true
  end

  def start
    user = current_user
    course = Course.find params[:id]

    unless user
      store_location payment_course_url(course)
      return redirect_to login_path
    end

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

  def require_take_part_in
    @course = Course.find params[:id]
    unless @course.participants.include? current_user.id
      flash[:error] = "尚未参加这门课程~"
      redirect_to root_path
    end
  end

  def require_course_exists
    course = Course.find_by_id(params[:id]) || Course.find_by_id(params[:course_id])
    redirect_to root_path unless course
  end

  def update_record
    user = current_user
    course = Course.find params[:id]

    user.courses.push(course.id)
    user.save!

    course.participants.push(user.id)
    course.save!
  end


end