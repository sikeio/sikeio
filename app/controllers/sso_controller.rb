class SsoController < ApplicationController

  before_action :require_login, :except => [:new]

  def new
    log_event("discourse-sso.init",params[:sso])
    check_signature
    session[:sso_nonce] = CGI.parse(Base64.decode64(params[:sso]))['nonce'].first
    if logged_in?
      redirect_to sso_succeed_path
    end
    # not logged in, should prompt user to login.
  end

  def succeed
    data = {
      name: current_user.name,
      username: current_user.github_username,
      email: current_user.email,
      nonce: session.delete(:sso_nonce),
      external_id: current_user.id,
    }
    log_event("discourse-sso.success",data)
    url_encoded_payload, sig = generate_params(data)
    host = ENV["DISCOURSE_HOST"]
    redirect_to "http://#{host}/session/sso_login?sso=#{url_encoded_payload}&sig=#{sig}"
  end

  private

  class IncorrectSSOSecret < RuntimeError ; end

  def check_signature
    sig = hmac_sha256(params[:sso])
    if sig != params[:sig]
      raise IncorrectSSOSecret
    end
  end

  def hmac_sha256(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['DISCOURSE_SSO_SECRET'], data)
  end

  def generate_params(data)
    payload = data.to_query
    base64_payload = Base64.encode64(payload)
    url_encoded_payload = CGI.escape(base64_payload)
    sig = hmac_sha256(base64_payload)
    return [url_encoded_payload, sig]
  end

end
