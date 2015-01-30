class Subscriber < ActiveRecord::Base

  before_create :downcase_email

  validates :email,{
    presence:{message:'地址不能为空~'},
    format:{with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i ,message:'格式不正确~'},
    uniqueness: {case_sensitive: false,message:'邮箱已经添加了~'}
  }


  private
  def downcase_email
    self.email.downcase!
  end

end