require 'rails_helper'

RSpec.describe Week, type: :model do
  describe "Create validate" do
    it 'should not create if no course to belong' do
      expect { Week.create! }.to raise_error
      
    end
  end
end
