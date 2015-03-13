class Week < ActiveRecord::Base
  belongs_to :course
  has_many :lessons, -> { order 'day ASC'}, dependent: :destroy

  validates :course, presence: true

end
