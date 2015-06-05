class UsersController < ApplicationController

  before_action :require_login, only: [:update_personal_info]
  before_action :require_correct_user, only: [:update_personal_info]

  def notes
    get_user
  end

  def note
    get_user
    @checkin = @user.checkins.find params[:checkin].last
  end

  def update_personal_info
    get_user
    @user.update_attribute :personal_info, params.require(:personal_info).permit(:blog, :twitter, :intro)
    head :ok
  end

  private
  def get_user
    return @user if defined? @user
    @user = User.find_by_github_username(params[:github_username])
    if @user.nil?
      flash[:error] = "不存在该用户!"
      redirect_to root_path
    end
  end

  def require_correct_user
    get_user
    if current_user != @user
      raise "Incorrect user attempts to update personal info!"
    end
  end


end
