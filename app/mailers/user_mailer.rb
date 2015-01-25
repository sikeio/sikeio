class UserMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: '欢迎来到思客教学')
  end


  def activation_email(user,content)
    @user = user
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @content = markdown.render content
    mail(to: @user.email, subject: '思客教学激活链接')
  end


end
