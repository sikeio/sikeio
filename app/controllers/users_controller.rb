class UsersController < ApplicationController

  before_action :require_login,only:[:dashbaord]
  before_action :require_right_user,only:[:dashbaord]


  def activation
    @user = User.find_by(id: params[:user_id])
    unless @user && @user.activation_token == params[:token]
      flash[:error] = 'Activation Token Error!'
      redirect_to root_path
    end
  end

  def activate
    user = User.find_by(id: params[:user_id])

    unless user && user.activation_token == params[:token]
      return redirect_to root_path
    end

    if !user.has_binded_github
      flash[:error] = "需要首先绑定GitHub！"
      redirect_to activation_user_path(user)
    else
      user.update! personal_info:info_params,has_been_activated:true
      login_as user
      redirect_to list_courses_path
    end
  end

  def dashboard
    @user = User.find params[:id]
  end

  private
  def info_params
    params.permit(:name,:blog_url,:type,experience:[])
  end

  def require_right_user
    unless current_user == User.find(params[:id])
      redirect_to root_path
    end
  end

end
