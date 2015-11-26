# == Schema Information
#
# Table name: subscribers
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Subscriber < ActiveRecord::Base

  before_create :downcase_email!

  validates :email, {
    presence: { message:'地址不能为空' },
    format: { with: /@/, message: '格式不正确' },
    uniqueness: true
  }


  private

  def downcase_email!
    self.email.downcase!
  end

end
