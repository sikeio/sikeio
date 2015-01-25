class Admin::SessionsController < Admin::ApplicationController

  before_action :require_admin,except:[:new,:create]

  def new
  end

  def create
    admins = CONFIG["admins"]
    if admins.one? {|h| h["email"] == params[:email] && h["password"] == params[:password] }
      session[:is_admin] = true
      redirect_to_back_or_default
    end
  end

end
