class AuthenticationsController < ApplicationController
  protect_from_forgery except: :callback

  def callback
    auth = Authentication.find_by uid: auth_info["uid"]
    if auth
      if params["github_binding"]
        flash[:error] = "此Github账号已经被绑定。请直接登录"
        redirect_to :root
      else
        login_as auth.user
        redirect_to_back_or_default params["back_path"]
      end
    else
      github_email = auth_info['info']['email']
      if user = User.find_by(email: github_email)
        create_authentication(user)
      else
        user = User.create name: auth_info['info']['nickname'], email: auth_info['info']['email']
        create_authentication(user)
      end
      login_as user
      redirect_to_back_or_default params["back_path"]
    end
  end

  def fail
    redirect_to request.env['omniauth.origin'] || :root
  end

  private

  def auth_info
    request.env["omniauth.auth"]
  end

  def params
    request.env["omniauth.params"]
  end

  def create_authentication(user)
    user.authentications.create(
      provider: 'github',
      uid: auth_info["uid"],
      info: auth_info["info"]
    )
  end

end
