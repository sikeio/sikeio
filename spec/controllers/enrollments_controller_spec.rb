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

        it 'should not create new enrollment if enrollment exists' do
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

      let(:personal_info) { {"blog_url" => "blog.com", "occupation" => "在职", "gender" => "妹子"} }

      describe "#invite" do
        it 'should render invite page' do
          get 'invite', id: @enrollment.token
          expect(response).to render_template(:invite)
        end

      end

      describe "#update" do

        it 'should redirect to invite page if github has not been binded' do
          put 'update', id: @enrollment.token, :personal_info => personal_info
          expect(response).to redirect_to(invite_enrollment_path(@enrollment))
        end

        describe "fill user info when github has been binded" do
          before(:each) do
            FactoryGirl.create(:authentication, user: user.id)
          end

          it 'should redirect to pay path if all info needed is filled when user has name' do
            put 'update', :personal_info => personal_info, id: @enrollment.token
            expect(response).to redirect_to(pay_enrollment_path(@enrollment))
          end

          it 'should redirect to pay path if all info needed is filled when user does not have name' do
            user.update(name: nil)
            put 'update', :personal_info => personal_info, id: @enrollment.token, user: {name: "name"}
            expect(response).to redirect_to(pay_enrollment_path(@enrollment))
          end

          it 'should redirect to invite page if not fill name if user does not have name' do
            user.update(name: nil)
            put 'update', :personal_info => personal_info, id: @enrollment.token, user: {name: nil}
            expect(response).to redirect_to(invite_enrollment_path(@enrollment))
          end

          it 'should redirect to invite page if not fill occupation' do
            personal_info["occupation"] = nil;
            put 'update', :personal_info => personal_info, id: @enrollment.token
            expect(response).to redirect_to(invite_enrollment_path(@enrollment))
          end

          it 'should redirect to invite page if not fill gender' do
            personal_info["gender"] = nil;
            put 'update', :personal_info => personal_info, id: @enrollment.token
            expect(response).to redirect_to(invite_enrollment_path(@enrollment))
          end
        end

      end

      describe "#pay" do
        before(:each) do
          @enrollment.update(personal_info: personal_info)
          FactoryGirl.create(:authentication, user: user.id)
        end

        it 'should redirect to course_path if enrollment has already been activated' do
          @enrollment.update(activated: true)
          get 'pay', id: @enrollment.token
          expect(response).to redirect_to(course_path(@enrollment.course))
        end

        it 'should redirect to invite_enrollment_path if has not bind github account' do
          user.authentications.delete_all
          get 'pay', id: @enrollment.token
          @enrollment.update(personal_info: personal_info)
          expect(response).to redirect_to(invite_enrollment_path(@enrollment))
        end

        describe "lack of personal info" do
          it 'should redirect to invite page if user has not binded github' do
            user.authentications.delete_all
            @enrollment.update(personal_info: personal_info)
            get 'pay', id: @enrollment.token
            expect(response).to redirect_to(invite_enrollment_path(@enrollment))
          end

          it 'should redirect to invite page if user has no name' do
            user.update(name: nil)
            @enrollment.update(personal_info: personal_info)
            get 'pay', id: @enrollment.token
            expect(response).to redirect_to(invite_enrollment_path(@enrollment))
          end

          it 'should redirect to invite page if no occupation info' do
            personal_info["occupation"] = nil
            @enrollment.update(personal_info: personal_info)
            get 'pay', id: @enrollment.token
            expect(response).to redirect_to(invite_enrollment_path(@enrollment))
          end

          it 'should redirect to invite page if no gender info' do
            personal_info["gender"] = nil
            @enrollment.update(personal_info: personal_info)
            get 'pay', id: @enrollment.token
            expect(response).to redirect_to(invite_enrollment_path(@enrollment))
          end
        end

        it 'should render to pay path if enroll not acticated and have all releated info' do
          @enrollment.update(personal_info: personal_info)
          get 'pay', id: @enrollment.token
          expect(response).to render_template(:pay)
        end

      end
    end

  end
end
