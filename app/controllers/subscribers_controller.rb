class SubscribersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # should always succeed... if not, it's pretty weird.
    subscriber = Subscriber.find_or_create_by(email: params[:email])
    if !subscriber.valid?
      render_400 "邮件订阅失败", subscriber.errors
      return
    end

    # BearychatMsgSenderJob.send_msg_to_staff "#{subscriber.email} 发出了迷你课程订阅申请，谁是管事的快处理一下！"
    UserMailer.index_welcome(subscriber.email).deliver_later

    render text: "订阅成功"
  end
end
