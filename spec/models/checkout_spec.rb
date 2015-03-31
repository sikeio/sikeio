# == Schema Information
#
# Table name: checkouts
#
#  id                   :integer          not null, primary key
#  enrollment_id        :integer
#  lesson_name          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  question             :text
#  solved_problem       :text
#  github_repository    :string
#  degree_of_difficulty :integer
#  time_cost            :integer
#

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
