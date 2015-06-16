class HomeController < ApplicationController

  before_action :anonymous_track, only: [:index]

  def index
    @ios_course = Course.find_by(name: "ios")
    @nodejs_course = Course.find_by(name: "nodejs")

    mixpanel_track(cookies.signed[:distinct_id], "Visited Home Page")
  end

end
