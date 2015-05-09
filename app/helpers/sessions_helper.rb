module SessionsHelper

  def current_user
    @current_user ||= login_with_session_or_cookies
  end

  def login_with_session_or_cookies
    if id = session[:user_id]
      User.find_by id: id
    elsif id = cookies.signed[:user_id]
      User.find_by id: id
    end
  end

  def login_as(user)
    session[:user_id] = user.id
    cookies.permanent.signed[:user_id] = user.id
  end

  def login?
    !!current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def require_login
    unless current_user
      flash[:error] = "请首先登陆~"
      store_location request.fullpath
      redirect_to login_path
    end
  end

end



