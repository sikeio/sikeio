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
    if enrollment.has_personal_info?
      redirect_to pay_enrollment_path(@enrollment)
      return
    end
    @course = @enrollment.course
    @user = @enrollment.user
  end

  def pay
    if request.get?
      if enrollment.activated
        redirect_to course_path(@enrollment.course)
        return
      end

      if !@enrollment.user.has_binded_github
        redirect_to invite_enrollment_path(@enrollment)
        return
      end
      if !@enrollment.has_personal_info?
        @enrollment.update_attribute :personal_info, params.require(:personal_info).permit(:blog_url, :type)
      end
      @course = @enrollment.course
    end

    if request.post?
      enrollment.buddy_name = params[:buddy_name]
      enrollment.save

      enrollment.start!

      redirect_to course_path(enrollment.course)
    end
  end

  private

  class InvalidEnrollmentTokenError < RuntimeError ; end
  class InvalidPersonalInfoError < RuntimeError ; end

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
