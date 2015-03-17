class CoursesController < ApplicationController

#  before_action :require_login,only:[:show, :start]
#  before_action :require_course_exists,except:[:list,:create_enroll]
#  before_action :require_take_part_in,only:[:show]
  protect_from_forgery except: :create_enroll


=begin
  def create_enroll
    require_course_exists params[:id]
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
=end
  def create_enroll
    
  end

  #list every courses for user to visit payment page
  def list
    @courses = Course.all
  end

  def show
    @course = Course.find params[:id]
    #@week_num = @course.weeks.maximum(:num)

    #order = @course.orders.find_by(user_id: session[:user_id])
    enrollment = @course.enrollment.find_by(user_id: 1)

    #Info needed to show
    @course_weeks = @course.course_weeks
    @course_week_titles = @course.course_week_titles
    @current_lesson_num = temp_num = enrollment.current_lesson_num
    @released_lesson_num = get_released_lesson_num(enrollment)
    @current_lesson = nil
    @lesson_sum = @course.lessons_sum
    @finished = (@current_lesson_num > @lesson_sum)
    @day_left = 0
    @send_day = 0

    #@weeks中是按照num排好序的
    require_day = 0
    @course.course_weeks_sum.times do |num|
      week_lessons = @course_weeks[num]
      if temp_num <= week_lessons.size
        lesson_info = week_lessons[temp_num - 1]
        @current_lesson = lesson_info[0]
        require_day += lesson_info[1]
        break
      else
        temp_num -= week_lessons.size
        require_day += 7
      end
    end
    
    start_time = enrollment.start_time.to_date
    start_day = start_time.cwday

    # 如果不是星期一申请成功开课的话，第一次开课时间为下周星期一
    start_time = start_time + 8 - start_day if start_day != 1 
    require_time = start_time + require_day
    today = Date.today
    @day_left = (require_time - today).to_i
    @send_day = today.day

  end

  def payment
    @course = Course.find params[:id]
    @display_top = true
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

  def get_released_lesson_num(enrollment)
    released_lesson_num = 0
    start_time = enrollment.start_time.to_date
    start_day = start_time.cwday

    # 如果不是星期一申请成功开课的话，第一次开课时间为下周星期一
    start_time = start_time + 8 - start_day if start_day != 1 
    start_year = start_time.cwyear
    start_week = start_time.cweek

    today = Date.today
    today_year = today.cwyear
    today_week = today.cweek
    day = today.cwday

    weeks = (today_year - start_year) * 53 + today_week - start_week
    if(weeks >= 0)
      weeks_sum = enrollment.course_weeks_sum
      if weeks >= weeks_sum
        released_lesson_num = enrollment.course.lessons_sum
      else
        (weeks).times do |n|
          released_lesson_num += enrollment.course.course_weeks[n].size
        end
        enrollment.course.course_weeks[weeks].size.times do |n|
          released_lesson_num += 1 if enrollment.course.course_weeks[weeks][n][1] <= day
          
        end
        released_lesson_num += enrollment.course.course_weeks[weeks].lessons.where("day <= #{day} ").count
      end
    end

    return released_lesson_num
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
