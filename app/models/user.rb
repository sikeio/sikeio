class User < ActiveRecord::Base
  has_many :authentications

  has_many :enrollments
  has_many :courses, through: :enrollments

  before_validation :normalize_email!
  before_create :reset_activation_token!

  validates :email,{
    presence: true,
    # http://davidcel.is/blog/2012/09/06/stop-validating-email-addresses-with-regex/
    format: { with: /@/ },
    uniqueness: true
  }

  # validates :name,presence:{message: '不能为空~'}

  scope :activated,->{ where(has_been_activated: true)}
  scope :unactivated,->{ where(has_been_activated: false)}

  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  def has_binded_github
    self.authentications.one? {|a| a.provider == 'github' }
  end

  def normalize_email!
    self.email = self.email.downcase.strip if self.email
  end

  def reset_activation_token!
    self.activation_token = SecureRandom.urlsafe_base64(64)
  end

end
