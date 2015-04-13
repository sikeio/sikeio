class TestMailer < ApplicationMailer
  def hello(email)
    mail(to: email, subject: "Test email sent - #{Time.now}")
  end
end
