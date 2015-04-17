class Admin::DashboardController < Admin::ApplicationController

  def index
    @courses = Course.all
  end

  def status
    @head_commit = `git log -n 1`.strip
    @env = ENV
  end

end