# == Schema Information
#
# Table name: lessons
#
#  id         :integer          not null, primary key
#  name       :string
#  title      :string
#  overview   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
