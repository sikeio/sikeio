class EnrollmentsController < ApplicationController
    def create
      if current_user
        Enrollment.create user:current_user,course: course
        #TODO: send email to admin
        head :ok
        return
      end
      user = User.new params.permit(:name,:email)
      if user.save
        Enrollment.create user:user,course: course
        UserMailer.welcome_email(user).deliver_later
        # TODO: send email to admin
        head :ok
      else
        render json:{msg: user.errors.full_messages},status: :bad_request
      end
    end

    def invite
      if enrollment.has_personal_info
        redirect_to pay_enrollment_path(@enrollment,token: @enrollment.token)
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
        @enrollment.update_attribute :personal_info, params[:personal_info]
        @enrollment.update_attribute :has_personal_info, true
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

    def course
      Course.find params[:course_id]
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
