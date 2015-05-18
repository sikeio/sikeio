class EnrollmentsController < ApplicationController
  def create
    if params[:name].blank? || params[:email].blank?
      render_400 "请输入你的姓名和邮箱"
      return
    end

    user = User.find_or_create_by(email: params[:email])
    user.name = params[:name]
    if !user.save
      render_400 "报名失败", user.errors
      return
    end

    @enrollment = Enrollment.find_or_initialize_by user_id: user.id, course_id: course.id
    # already enrolled
    if !enrollment.new_record?
      head :ok
      return
    end

    # create new enrollment
    if !enrollment.save
      render_400 "报名失败", enrollment.errors
      return
    else
      UserMailer.welcome(enrollment).deliver_later
      head :ok
    end
  end

  def invite
    if current_user && enrollment.user != current_user
      enrollment.update_attribute :user, current_user
    end
    @course = enrollment.course
    @user = enrollment.user
  end

  def update
    user = enrollment.user
    if user.name.blank?
      name = params[:user][:name]
      if name.present?
        user.update_attribute :name, name
      end
    end

    enrollment.update_attribute :personal_info, params.require(:personal_info).permit(:blog_url, :occupation, :gender)

    if !user_info_completed?
      redirect_to_invite
      return
    end

    if enrollment.course.free
      activate_course
      return
    end

    redirect_to pay_enrollment_path(@enrollment)
  end

  def pay
    if !user_info_completed?
      redirect_to_invite
      return
    end

    if enrollment.activated
      redirect_to course_path(@enrollment.course)
      return
    end

    @course = @enrollment.course
  end

  # POST
  def finish
    enrollment.buddy_name = params[:buddy_name]
    enrollment.save
    activate_course
  end


  private

  class InvalidEnrollmentTokenError < RuntimeError ; end
  class InvalidPersonalInfoError < RuntimeError ; end

  def activate_course
    enrollment.activate!
    login_as enrollment.user
    redirect_to course_path(enrollment.course)
  end

  def user_info_completed?
    if enrollment.user.name.blank?
      flash[:error] = "请输入您的姓名"
      return false
    elsif !enrollment.user.has_binded_github
      flash[:error] = "请绑定Github"
      return false
    elsif enrollment.personal_info["gender"].blank?
      flash[:error] = "请选择您的性别"
      return false
    elsif enrollment.personal_info["occupation"].blank?
      flash[:error] = "请选择您的职业"
      return false
    else
      return true
    end
  end

  def redirect_to_invite
    redirect_to invite_enrollment_path(@enrollment)
  end

  def course
    @course ||= Course.by_param!(params[:course_id])
  end

  def enrollment
    return @enrollment if defined?(@enrollment)
    @enrollment = Enrollment.find_by(token: params[:id])
    if @enrollment.nil? || (params[:token] && @enrollment.token != params[:token])
      raise InvalidEnrollmentTokenError
    else
      @enrollment
    end
  end

end
