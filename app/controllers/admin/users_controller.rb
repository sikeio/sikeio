class Admin::UsersController < Admin::ApplicationController

  def index
    @users = User.all
  end


  def send_activation_email


    #TODO setup backend job system
    UserMailer.activation_email(user,params[:content]).deliver_later
    head :ok
  end

  def login
    login_as(user)
    redirect_to "/courses"
  end

  private

  def user
    user ||= User.find_by_github_username(params[:user_id])
  end


end
