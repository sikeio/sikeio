class CoursesController < ApplicationController

  before_action :require_login,only:[:show]
  before_action :require_course_exists,except:[:list]
  before_action :require_take_part_in,only:[:show]
  

  def enroll
    @course = Course.find params[:id]

    redirect_to payment_course_path(@course) if current_user
  end

  def create_enroll
    result = {}
    course = Course.find params[:id]

    if params[:type] == "new_user"
      user = User.new(params.permit(:email,:name))
      if user.save
        result['success'] = true
        result['msg'] = "注册成功~请去邮箱检查邮件吧~"
      else
        result['success'] = false
        result['msg'] = user.errors.full_messages
      end
    else
      user = User.find_by_email(params[:email].downcase)
      if user && user.has_been_activated
        if course.include_user?(user)
          result['success'] = false
          result['msg'] = '已经加入课程了~'
        else
          return render js: "window.location = '#{payment_course_url(course)}'"
        end
      else
        result['success'] = false
        result['msg'] = '用户不存在或者未激活~'
      end
    end

    render json: result
    if result['success'] == true
      UserMailer.welcome_email(user).deliver_later
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

  private

  def require_take_part_in
    @course = Course.find params[:id]
    unless @course.participants.include? current_user.id
      flash[:error] = "尚未参加这门课程~"
      redirect_to root_path
    end
  end

  def require_course_exists
    @course = Course.find_by_id params[:id]
    redirect_to root_path unless @course
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