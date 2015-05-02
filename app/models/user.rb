# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string
#  email              :string
#  personal_info      :json
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  has_been_activated :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_many :authentications

  has_many :enrollments
  has_many :courses, through: :enrollments

  before_validation :normalize_email!

  validates :email,{
    presence: true,
    # http://davidcel.is/blog/2012/09/06/stop-validating-email-addresses-with-regex/
    format: { with: /@/ },
    uniqueness: true
  }

  # validates :name,presence:{message: '不能为空~'}
  validates :name, {
    presence: true
  }

  scope :activated,->{ where(has_been_activated: true)}
  scope :unactivated,->{ where(has_been_activated: false)}

  def has_binded_github
    self.authentications.one? {|a| a.provider == 'github' }
  end

  def normalize_email!
    self.email = self.email.downcase.strip if self.email
  end

  def github
    self.authentications.find_by provider: 'github'
  end

  def github_username
    github.nickname
  end

end
