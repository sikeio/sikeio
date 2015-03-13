class User < ActiveRecord::Base
  has_many :authentications

  has_many :orders, dependent: :destroy
  has_many :courses, through: :orders

  before_save :downcase_email
  before_create :fill_activation_token

  validates :email,{
    presence:{message:'不能为空~'},
    format:{with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i ,message:'格式不正确~'},
    # uniqueness: {case_sensitive: false,message:'地址已经被注册了~'}
  }

  validates :name,presence:{message: '不能为空~'}

  scope :activated,->{ where(has_been_activated: true)}
  scope :unactivated,->{ where(has_been_activated: false)}

  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  def has_binded_github
    self.authentications.one? {|a| a.provider == 'github' }
  end

  private
  def downcase_email
    self.email.downcase!
  end

  def fill_activation_token
    self.activation_token = User.generate_token
  end

end
