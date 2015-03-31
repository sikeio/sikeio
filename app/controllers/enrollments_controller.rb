class EnrollmentsController < ApplicationController
    def create
      # require_course_exists params[:id]
      # result = {}
      # user = User.new(params.permit(:email,:name))
      # if user.save
      #   result['success'] = true
      # else
      #   result['success'] = false
      #   result['msg'] = user.errors.full_messages
      # end

      # render json: result
      # if result['success'] == true
      #   UserMailer.welcome_email(user).deliver_later! wait: (30 + rand(30)).minutes
      # end
      head :ok
    end

end
