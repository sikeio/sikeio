# == Schema Information
#
# Table name: lessons
#
#  id                 :integer          not null, primary key
#  name               :string
#  title              :string
#  overview           :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  course_id          :integer
#  permalink          :string
#  bbs                :string
#  discourse_topic_id :integer
#  project            :string
#

require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
