class HomeController < ApplicationController

  def index
    flash[:error] = '用户名或者密码错误！'
    @ios_course = Course.find_by(name: "ios")
    @nodejs_course = Course.find_by(name: "nodejs")
  end

end
