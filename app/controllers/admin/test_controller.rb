class Admin::TestController < Admin::ApplicationController
  def send_email
    email = params[:email]
    msg = params[:message]
    TestMailer.hello(email,msg).deliver_now!
    render text: "email sent"
  end

  def show_flash
    if error = params[:error]
      flash[:error] = error
    end

    redirect_to "/"
  end
end