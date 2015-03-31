class UsersController < ApplicationController

  before_action :require_login,only:[:dashboard]
  before_action :require_right_user,only:[:dashboard]


  # def activation
  #   @user = User.find_by_id params[:id]
  #   unless @user && @user.activation_token == params[:token]
  #     flash[:error] = 'Activation Token Error!'
  #     redirect_to root_path
  #   end
  #   @display_top = true
  #   @course_name = "iOS基础训练营"
  #   @course_desc = "我们计划 10/17 号周一正式开始，之后四周每周各做一个小应用。和自己看书不一样的是训练营会有其他小伙伴一起和你一起学习，你遇到的问题相信还有别人也会遇到，所以大家不要不好意思提问哦！"
  # end

  def activate
    user = User.find_by(id: params[:user_id])

    unless user && user.activation_token == params[:token]
      flash[:error] = 'Activation Token Error!'
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
    unless current_user == User.find_by_id(params[:id])
      redirect_to root_path
    end
  end

end
