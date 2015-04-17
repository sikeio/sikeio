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

    @enrollment = Enrollment.find_or_create_by user_id: user.id, course_id: course.id
    if !enrollment.save
      render_400 "报名失败", enrollment.errors
      return
    end

    head :ok
  end

  def invite
    if enrollment.has_personal_info?
      redirect_to pay_enrollment_path(@enrollment, token: @enrollment.token)
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
      @enrollment.update_attribute :personal_info, params.require(:personal_info).permit(:blog_url, :type)
      @course = @enrollment.course
    end

    if request.post?
      enrollment.buddy_name = params[:buddy_name]
      enrollment.activated = true
      enrollment.save
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
