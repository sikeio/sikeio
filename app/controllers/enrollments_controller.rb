class EnrollmentsController < ApplicationController
  def create
    user = User.find_or_create_by(email: params[:email])
    user.name = params[:name]
    if !user.save
      render json: { msg: user.errors.full_messages }, status: :bad_request
      return
    end

    # TODO use an actual course
    @course = Course.first
    @enrollment = Enrollment.find_or_create_by user_id: user.id, course_id: course.id
    if !enrollment.save
      render json: { msg: enrollment.errors.full_messages }, status: :bad_request
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
      elsif !@enrollment.user.has_binded_github
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
    @course ||= Course.find params[:course_id]
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
