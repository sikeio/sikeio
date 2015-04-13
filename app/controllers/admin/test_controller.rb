class Admin::TestController < Admin::ApplicationController
  def send_email
    email = params[:email]
    msg = params[:message]
    TestMailer.hello(email,msg).deliver_now!
    render text: "email sent"
  end
end