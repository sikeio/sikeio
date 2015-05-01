class AuthenticationsController < ApplicationController
  protect_from_forgery except: :callback

  def callback
    logger.info({
      event: "oauth.success",
      payload: payload,
      params: auth_params
    }.to_json)

    auth = find_or_create_authentication
    login_as auth.user
    redirect_to_back_or_default auth_params["back_path"]
  end

  def fail
    redirect_to request.env['omniauth.origin'] || :root
  end

  private

  def payload
    request.env["omniauth.auth"]
  end

  def info
    payload["info"]
  end

  def auth_params
    request.env["omniauth.params"]
  end

  def auth_email
    info['email'].downcase
  end

  def find_or_create_user
    user = User.find_by(email: auth_email)

    if user.nil?
      user = User.create! name: info['name'], email: auth_email
    end

    return user
  end

  def find_or_create_authentication
    auth = Authentication.find_by uid: payload["uid"]
    if auth
      auth.user.update_attributes(email: auth_email)
      return auth
    end

    user = find_or_create_user
    user.authentications.create!(payload)
  end

end
