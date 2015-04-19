class UsersController < ApplicationController

  before_action :require_login,only:[:dashboard]

  def dashboard
    @user = User.find params[:id]
  end

end
