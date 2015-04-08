class Admin::ApplicationController < ApplicationController
  layout 'admin'
  #before_action :require_admin

  def require_admin
    unless session[:is_admin] == true
      store_location
      redirect_to admin_login_path
    end
  end

  def redirect_to_back_or_default
    if session[:location].present?
      redirect_to session.delete(:location)
    else
      redirect_to admin_dashboard_path
    end
  end




end
