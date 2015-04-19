class HomeController < ApplicationController

  def index
    @ios_course = Course.find_by(name: "ios")
    @nodejs_course = Course.find_by(name: "nodejs")
  end

end
