# Preview all emails at http://localhost:3000/rails/mailers/user
class UserMailerPreview < ActionMailer::Preview

  def welcome_email
    @abc = params[:name]
    user = User.last
    UserMailer.welcome_email(user)
  end

end
