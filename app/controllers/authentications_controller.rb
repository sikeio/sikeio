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
      if current_user
        create_authentication
      else
        flash[:error] = "您当前并未接受思客训练营邀请！请首先报名课程接受邀请。"
        redirect_to :root
      end
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

  def create_authentication
    current_user.update_attribute :email, auth_info['info']['email']
    current_user.authentications.create(
      provider: 'github',
      uid: auth_info["uid"],
      info: auth_info["info"]
    )
    flash[:info] = "您在思客站点的Email已经更新为#{current_user.email},此后,思客将使用该Email与您进行通信。"
    redirect_to_back_or_default params["back_path"]
  end

end
