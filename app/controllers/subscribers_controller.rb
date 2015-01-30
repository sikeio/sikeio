class SubscribersController < ApplicationController

  def create
    result = {}
    s = Subscriber.new params.permit(:email)
    if s.save
      result['success'] = true
    else
      result['success'] = false
      result['msg'] = s.errors.full_messages
    end
    render json: result
  end

end