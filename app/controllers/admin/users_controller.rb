class Admin::UsersController < Admin::ApplicationController

  def index
    @users = User.all
  end


  def send_activation_email
    user = User.find(params[:user_id])

    #TODO setup backend job system
    UserMailer.activation_email(user,params[:content]).deliver_later
    head :ok
  end


end