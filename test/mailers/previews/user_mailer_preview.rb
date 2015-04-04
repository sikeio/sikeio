# Preview all emails at http://localhost:3000/rails/mailers/user
class UserMailerPreview < ActionMailer::Preview

  def welcome_email
    user = User.last
    UserMailer.welcome_email(user)
  end

  def invitation_email
    enrollment = Enrollment.last
    content = "#This is the invitation email"
    UserMailer.invitation_email(enrollment,content)
  end

end
