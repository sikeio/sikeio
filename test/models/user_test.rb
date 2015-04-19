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


end
