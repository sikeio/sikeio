class CheckoutsController < ApplicationController

  #before_action :require_login
  before_action :require_lesson_exists
  before_action :require_enrollment_exists
  before_action :require_course_has_lesson
  #before_action :require_enrolled

  def new
    enrollment = Enrollment.find_by(id: params[:enroll_id])
    lesson = Lesson.find params[:lesson_id]
    check_out_info = {
                      enrollment_id: enrollment.id,
                      lesson_name: lesson.name,
                      degree_of_difficulty: params[:degree_of_difficulty].to_i,
                      github_repository: params[:github_repository],
                      solved_problem: params[:solved_problem],
                      question: params[:question],
                      time_cost: params[:time_cost]
                    }
    check = Checkout.new(check_out_info)
    result = {}
    if check.save
      render js: "window.location='#{course_path(enrollment.course_id)}'"
    else
      result[:success] = false
      result[:message] = check.errors.full_messages
      render json: result 
    end
  end

  private

  def require_lesson_exists
    redirect_to root_path unless Lesson.find_by(id: params[:lesson_id])
  end

  def require_enrollment_exists
    redirect_to root_path unless Enrollment.find_by(id: params[:enroll_id])
  end

  def require_enrolled
    user_id = session[:user_id]
    user = User.find_by(id: user_id)
    enrollment = Enrollment.find_by(id: params[:enroll_id])
    unless user
      redirect_to root_path
    else
      redirect_to root_path unless user.enrollments.any? { |user_enrollment| user_enrollment == enrollment }
    end
  end

  def require_course_has_lesson
    enrollment = Enrollment.find_by(id: params[:enroll_id])
    lesson = Lesson.find_by(id: params[:lesson_id])
    course_id = enrollment.course_id
    if course = Course.find_by(id: course_id)
      redirect_to root_path unless course.lessons.any? { |course_lesson| course_lesson == lesson}
    else
      redirect_to root_path
    end
  end

end
