class Admin::DashboardController < Admin::ApplicationController

  def index
    @courses = Course.all
  end

end