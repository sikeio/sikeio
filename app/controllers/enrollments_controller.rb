class EnrollmentsController < ApplicationController
  def create
    course
    email = params[:email]
    user = User.find_or_create_by!(email: email)
    enrollment = Enrollment.find_or_initialize_by(user: user, course: course)
    if !enrollment.new_record?
      render text: "already enrolled"
      return
    end

    if enrollment.save
      render text: "enrolled"
    else
      render json: enrollment.errors
    end
  end

  private

  def course
    @course ||= Course.find_by!(name: params[:course_id])
  end
end