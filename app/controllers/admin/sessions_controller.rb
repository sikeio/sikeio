class Admin::SessionsController < Admin::ApplicationController

  ADMIN_PASSWORD = ENV["ADMIN_PASSWORD"]

  before_action :require_admin,except:[:new,:create]

  def new
  end

  def create
    admins = CONFIG["admins"]
    if params[:password] == ADMIN_PASSWORD
      session[:is_admin] = true
      redirect_to_back_or_default
    end
  end

end
