require 'rails_helper'

RSpec.describe EnrollmentsController, type: :controller do

  describe "enrollment flow" do

    let(:test_course) do
      Course.create(name: "ios", permalink: "test")
    end

    let(:register_info) do
      {email: "abcd@gmail.com", name: "abcd", course_id: test_course.permalink}
    end

    let(:user) do
      User.create(email: register_info[:email], name: register_info[:name])
    end

    describe "enroll" do
      it 'renders 400 if name is blank' do
        register_info[:name] = ""
        xhr :post, 'create', register_info
        expect(response).to have_http_status(400)
      end

      it 'renders 400 if email is blank' do
        register_info[:email] = ""
        xhr :post, 'create', register_info
        expect(response).to have_http_status(400)
      end

      it 'returns ok if already enroll' do
        Enrollment.create(user_id: user.id, course_id: test_course.id)
        xhr :post, 'create', register_info
        expect(response).to have_http_status(200)
      end

      it 'returns ok if enroll successful' do
        xhr :post, 'create', register_info
        expect(response).to have_http_status(200)
      end

    end

    describe "invite" do

    end

    describe "pay" do

    end

  end


end
