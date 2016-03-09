class Admin::SessionsController < Admin::ApplicationController

  ADMIN_PASSWORD = ENV["ADMIN_PASSWORD"]

  before_action :require_admin,except:[:new,:create]

  def new
  end

  def create
    if params[:password] == ADMIN_PASSWORD
      session[:is_admin] = true
      # render text: "ok"

      # redirect_to "/admin"
      redirect_to_back_or_default
    else
      render text: "login failed"
    end
  end

end
