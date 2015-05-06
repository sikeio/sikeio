require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do



  let(:auth_success) do
    user = FactoryGirl.build(:user)
    request.env["omniauth.auth"] = {
      'provider' => 'github',
      'uid' => '12345',
      'info' => {
        "nickname" => "haha",
        "email" => user.email,
        "name" => user.name
      }
    }
    request.env["omniauth.params"] = {}
  end


  describe "#callback" do
    before(:each) do
      auth_success
    end

    it 'should not create new user if user exist' do
      FactoryGirl.create(:user)
      expect{ get 'callback', provider: :github }.not_to change{ User.count }
    end

    it 'should create new authentication if user exit but no auth' do
      FactoryGirl.create(:user)
      expect{ get 'callback', provider: :github }.to change{ Authentication.count }.by(1)
    end

    it 'should create new user if user not exist' do
      expect{ get 'callback', provider: :github }.to change{ User.count }.by(1)
    end

    it 'should create new auth after create new user' do
      expect{ get 'callback', provider: :github }.to change{ Authentication.count }.by(1)
    end

    it 'should login as the auth user' do
      user = FactoryGirl.create(:user)
      get 'callback', provider: :github
      expect(session[:user_id]).to eq(user.id)
    end

    it 'should redirect to back_path if given' do
      request.env["omniauth.params"] = {"back_path" => login_path}
      get 'callback', provider: :github
      expect(response).to redirect_to(login_path)
    end

    it 'should redirect to root path if no back path' do
      get 'callback', provider: :github
      expect(response).to redirect_to(root_path)
    end
  end

  describe "#fail" do

    it 'should redirect to path before auth if path given' do
      request.env['omniauth.origin'] = login_path
      get 'fail', provider: :github
      expect(response).to redirect_to(login_path)
    end

    it 'should redirect to root path if no path given' do
      get 'fail', provider: :github
      expect(response).to redirect_to(root_path)
    end
  end

end
