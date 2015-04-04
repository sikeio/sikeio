# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string
#  email              :string
#  activation_token   :string
#  personal_info      :json
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  has_been_activated :boolean          default(FALSE)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = User.new(name:'ding',email:'ABC@abc.com')
  end

  test 'should downcase the email before save' do
    @user.save
    assert_equal @user.email,'abc@abc.com'

    @user.update email: 'DDD@DDD.com'
    assert_equal @user.email, 'ddd@ddd.com'
  end

  test 'should generate activation token before create' do
    @user.save
    token = @user.activation_token

    assert_not_empty token

    @user.save
    assert_not_empty @user.activation_token
    assert_equal token,@user.activation_token
  end

end
