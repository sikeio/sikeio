class SubscribersController < ApplicationController
  def create
    # should always succeed... if not, it's pretty weird.
    subscriber = Subscriber.find_or_create_by(email: params[:email])
    if !subscriber.valid?
      render_400 "邮件订阅失败", subscriber.errors
      return
    end

    head :ok
  end
end