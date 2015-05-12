class Admin::TestController < Admin::ApplicationController
  def send_email
    email = params[:email]
    msg = params[:message]
    TestMailer.hello(email,msg).deliver_now!

    render text: "email sent"
  rescue RestClient::BadRequest => e
    render text: "send error:\n#{e.response.body.force_encoding("utf-8")}"
  end

  def show_flash
    if error = params[:error]
      flash[:error] = error
    end

    redirect_to "/"
  end
end