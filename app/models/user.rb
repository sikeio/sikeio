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
  has_many :checkins, through: :enrollments

  before_validation :normalize_email!

  validates :email,{
    presence: true,
    # http://davidcel.is/blog/2012/09/06/stop-validating-email-addresses-with-regex/
    format: { with: /@/ , message: "Email 格式不正确~"},
    uniqueness: { message: "该Email 已被使用~"}
  }

  # validates :name,presence:{message: '不能为空~'}
  # validates :name, {
  #   presence: true
  # }

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

  def avatar
    github.info["info"]["image"]
  end

  def ensure_discourse_user
    return if self.discourse_user_id || self.authentications.blank?

    username = self.github_username.gsub(/-/, "_")
    temp_discourse_user = discourse_user(username)
    temp_discoure_user_id = nil
    if temp_discourse_user
      temp_discoure_user_id = temp_discourse_user["id"]
    else
      temp_discoure_user_id = create_discourse_user(username)
    end

    self.update!(discourse_user_id: temp_discoure_user_id, discourse_username: username)
  end

  def self.ensure_discourse_users
    users = self.where(discourse_user_id: nil)
    users.each do |u|
      u.ensure_discourse_user
    end
  end



  private

  class CreateDiscourseUserFail < RuntimeError ; end

  def discourse_user(username)
    url = ENV["DISCOURSE_HOST"] + "/admin/users/#{username}.json"
    begin
      r = RestClient.get url, :params => {:api_key => ENV["DISCOURSE_TOKEN"], :api_username => ENV["DISCOURSE_ADMIN"]}
      return JSON.parse(r.body)
    rescue => e
      return nil
    end
  end


  def create_discourse_user(username)
    url = ENV["DISCOURSE_HOST"] + "/users"

    r = RestClient.post url, {
      :username => username,
      :email => self.email,
      :password => SecureRandom.hex(10), # Find a way to generate password
      :active => true
    },{
      :accept => :json,
      :params => {
        :api_key => ENV["DISCOURSE_TOKEN"],
        :api_username => ENV["DISCOURSE_ADMIN"]
      }
    }
    result = JSON.parse(r.body)
    result["user_id"]
  end

end
