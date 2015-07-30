class HomeController < ApplicationController

  BACKGROUND = {"design101" => "courses/design/design.jpg", "css0to1" => "courses/css/css.jpg", "ios" => "courses/ios/ios.jpg", "nodejs" => "courses/nodejs/nodejs.jpg"}

  TITLE = {"home" => "满足您的技术情怀", "design101" => "用 Sketch 做出逼格破表的设计", "css0to1" => "你也可以写出简洁优美的 CSS", "nodejs" => "NodeJS 高速道路", "ios" => "iOS 攀爬第一个高峰"}

  COURSE_NAME = {"home" => "迷你课程", "css0to1" => "从 0 到 1 实现响应式个人网站", "nodejs" => "NodeJS Express Way", "ios" => "iOS", "design101" => "码农设计初体验"}

  before_action :anonymous_track, only: [:index]

  def index
    has_info = %w[nodejs design101 css0to1 ios].any? {|c| c == params[:course]}
    template_name = has_info ? params[:course] : "home"
    if template_name != "home"
      @course = Course.find_by_permalink(@course_show)
    end

    @show_info = show_info(template_name)

    render template_name

    mixpanel_register(share: params[:share] || "direct")
    mixpanel_track(cookies.signed[:distinct_id], "Visited Home Page")
  end

  private

  def show_info(type)
    {
      :background => BACKGROUND[type],
      :title => TITLE[type],
      :course_name => COURSE_NAME[type],
      :home_index => (type == "home" ? true : false),
      :page_at => type,
      :enroll_permalink => type
    }
  end

end
