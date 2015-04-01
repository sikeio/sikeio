class AuthenticationsController < ApplicationController
  protect_from_forgery except: :callback

  def callback
    auth_info = request.env["omniauth.auth"]
    params = request.env["omniauth.params"]

    auth = Authentication.find_by uid: auth_info["uid"]
    if auth
      if params["binding_github"]
        flash[:error] = "此Github账号已经被绑定。请直接登录"
        return redirect_to :root
      end
      login_as auth.user
      redirect_to_back_or_default params["back_path"]
    else
      user = User.find_by_id params["user_id"]
      redirect_to root_path unless user

      user.authentications.create(
        provider: 'github',
        uid: auth_info["uid"],
        info: auth_info["info"]
      )
      login_as user
      redirect_to_back_or_default params["back_path"]
    end
  end
end
