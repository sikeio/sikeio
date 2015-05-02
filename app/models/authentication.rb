# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  uid        :string
#  provider   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  info       :json
#

class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :uid, :uniqueness => true

  scope :github, -> { where(provider: "github")}
end
