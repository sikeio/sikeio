class UsersController < ApplicationController

  def notes
    get_user
  end

  def note
    get_user
    @checkin = @user.checkins.find params[:checkin].last
  end

  private
  def get_user
    @user = User.find_by_github_username(params[:github_username])
    if @user.nil?
      flash[:error] = "不存在该用户!"
      redirect_to root_path
    end
  end


end
