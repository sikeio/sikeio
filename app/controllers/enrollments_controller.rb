class EnrollmentsController < ApplicationController
    def create
      course = Course.find(params[:courseId])
      result = {}
      if current_user
        Enrollment.create user:current_user,course: course
        # TODO send email to admin
        head :ok
      else
        user = User.new params.permit(:name,:email)
        if user.save
          Enrollment.create user:user,course: course
          # UserMailer.welcome_email(user).deliver_later! wait: (30 + rand(30)).minutes
          UserMailer.welcome_email(user).deliver_later
          # TODO: send email to admin
          head :ok
        else
          result['msg'] = user.errors.full_messages
          render json:result,status: :bad_request
        end
      end
    end

    def invite
      token = params[:token]
      @enrollment = Enrollment.find params[:id]
      redirect_to :root unless @enrollment.token == token
      redirect_to pay_enrollment_path(@enrollment,token: @enrollment.token) if @enrollment.data["has_visited_invite"]
      @course = @enrollment.course
      @user = @enrollment.user
    end

    def pay
      @enrollment = Enrollment.find params[:id]

      return redirect_to :root unless params[:token] == @enrollment.token
      return redirect_to invite_enrollment_path(@enrollment,token: @enrollment.token) unless @enrollment.user.has_binded_github
      return redirect_to course_path(@enrollment.course) if @enrollment.data['has_visited_pay']

      data =  params[:data] || @enrollment.data
      data["has_visited_invite"] = true
      @enrollment.update_attribute :data,data

      @course = @enrollment.course
    end

    def finish
      enrollment = Enrollment.find params[:id]
      enrollment.data['buddy_name'] = ( params[:buddy_name].empty?  ? nil : params[:buddy_name] )
      enrollment.data['activated'] = true
      enrollment.data["has_visited_pay"] = true
      enrollment.save
      redirect_to course_path(enrollment.course)
    end

end
