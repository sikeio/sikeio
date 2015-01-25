module SessionsHelper

  def current_user
    @current_user ||= login_with_session
  end

  def login_with_session
    if session[:user_id]
      User.find_by id: session[:user_id]
    end
  end

  def login_as(user)
    session[:user_id] = user.id
  end

  def login?
    !!current_user
  end

  def require_login
    unless current_user
      flash[:error] = "请首先登陆~"
      redirect_to login_path
    end
  end

end



