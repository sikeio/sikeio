class HomeController < ApplicationController

  before_action :anonymous_track, only: [:index]

  def index
    @ios_course = Course.find_by(name: "ios")
    @nodejs_course = Course.find_by(name: "nodejs")
    has_info = %w[nodejs design101 css0to1 ios].any? {|c| c == params[:course]}
    @course_show = has_info ? params[:course] : "home"
    if @course_show != "home"
      @course = Course.find_by_permalink(@course_show)
    end

    render @course_show

    mixpanel_register(share: params[:share] || "direct")
    mixpanel_track(cookies.signed[:distinct_id], "Visited Home Page")
  end

end
