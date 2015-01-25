class AuthenticationsController < ApplicationController

  def callback
    auth_info = request.env["omniauth.auth"]
    params = request.env["omniauth.params"]

    auth = Authentication.find_by uid: auth_info["uid"]
    if auth
      login_as auth.user
      redirect_to_back_or_default dashboard_user_path(auth.user)
    else
      user = User.find_by_id params["user_id"]
      redirect_to root_path unless user

      user.authentications.create(
        provider: 'github',
        uid: auth_info["uid"],
        info: auth_info["info"]
      )

      redirect_to activation_user_path(user)
    end
  end
end
