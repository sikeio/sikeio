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

require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
