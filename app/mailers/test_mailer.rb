class TestMailer < ApplicationMailer
  def hello(email,message)
    @message = message
    mail(to: email, subject: "Test email sent - #{Time.now}")
  end
end
