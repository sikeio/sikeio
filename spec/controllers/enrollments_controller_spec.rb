require 'rails_helper'

RSpec.describe EnrollmentsController, type: :controller do

  describe "enrollment flow" do

    let(:test_course) do
      Course.first
    end

    let(:user) do
      FactoryGirl.create(:user)
    end

    describe "create enrollment" do
      describe "#create" do

        let(:register_info) do
          {email: "abcd@gmail.com", name: "abcd", course_id: test_course.permalink}
        end

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
          temp_enroll = FactoryGirl.create(:enrollment, user: user.id, course: test_course.id)
          xhr :post, 'create', email: user.email, name: user.name, course_id: test_course.permalink
          expect(response).to have_http_status(200)
        end

        it 'returns ok if enroll successful' do
          xhr :post, 'create', register_info
          expect(response).to have_http_status(200)
        end

        it 'should create new enrollment if entollment not exists' do
          expect{xhr :post, 'create', register_info}.to change{ Enrollment.count }.by(1)
        end

        it 'should note create new enrollment if enrollment exists' do
          temp_enroll = FactoryGirl.create(:enrollment, user: user.id, course: test_course.id)
          expect{
            xhr :post, 'create', email: user.email, name: user.name, course_id: test_course.permalink
          }.not_to change{ Enrollment.count }
        end

      end
    end


    describe "update exist enrollment info" do
      before(:each) do
        request.session[:user_id] = user.id
        @enrollment = FactoryGirl.create(:enrollment, user: user.id, course: test_course.id)
      end


      let(:personal_info) { {"blog_url" => "blog.com", "occupation" => "在职"} }

      describe "#invite" do

        it 'should render invite page if does not have personal info' do
          get 'invite', id: @enrollment.token
          expect(response).to render_template(:invite)
        end
      end

      describe "#update" do
        it 'should redirect to invite page if github has not been binded' do
          get 'update', id: @enrollment.token
          expect(response).to redirect_to(invite_enrollment_path(@enrollment))
        end

        it 'should update personal info with given information if github has been binded' do
          FactoryGirl.create(:authentication, user: user.id)
          put 'update', :personal_info => personal_info, id: @enrollment.token
          expect(@enrollment.reload.personal_info).to eq(personal_info)

        end

        it 'should redirect to pay enrollment path after update if github has binded' do
          FactoryGirl.create(:authentication, user: user.id)
          put 'update', :personal_info => personal_info, id: @enrollment.token
          expect(response).to redirect_to(pay_enrollment_path(@enrollment))
        end
      end

      describe "#pay" do
        it 'should redirect to course_path if enrollment has already been activated' do
          @enrollment.update(activated: true)
          get 'pay', id: @enrollment.token
          expect(response).to redirect_to(course_path(@enrollment.course))
        end

        it 'should redirect to invite_enrollment_path if has not bind github account' do
          get 'pay', id: @enrollment.token
          @enrollment.update(personal_info: personal_info)
          expect(response).to redirect_to(invite_enrollment_path(@enrollment))
        end

        it 'should redirect to invite_enrollment_path if does not have personal_info ' do
          get 'pay', id: @enrollment.token
          Authentication.create(user_id: user.id, provider: "github")
          expect(response).to redirect_to(invite_enrollment_path(@enrollment))
        end

        it 'should render to pay path if enroll not acticated and have all releated info' do
          @enrollment.update(personal_info: personal_info)
          Authentication.create(user_id: user.id, provider: "github")
          get 'pay', id: @enrollment.token
          expect(response).to render_template(:pay)
        end

      end
    end

  end


end
