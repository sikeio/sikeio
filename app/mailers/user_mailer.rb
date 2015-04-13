class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: '欢迎来到思客教学')
  end


  def invitation_email(enrollment,content)
    @enrollment = enrollment
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @content = markdown.render content
    mail(to: @enrollment.user.email, subject: '思客教学邀请函')
  end


end
