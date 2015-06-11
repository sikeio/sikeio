class ApplicationController < ActionController::Base

  include SessionsHelper

  include EventLogging


  def anonymous_track
    if !cookies[:distinct_id]
      cookies.permanent.signed[:distinct_id] = SecureRandom.uuid()
      referrer = request.referrer || "direct"
      utm_source = params["utm_source"] || "direct"
      mixpanel_register({ "Referer" => referrer, "UTM" => utm_source })
    end
  end

  # 301 Permanent Redirect from besike.com to sike.io
  if Rails.env.production?
    before_filter :sikeio_redirect

    def sikeio_redirect
      # p [request.host,request.path]
      if request.host == "besike.com"
        uri = URI.parse(request.url)
        uri.host = "sike.io"
        redirect_to uri.to_s, status: 301
        return false
      end
      return true
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :page_identifier

  def page_identifier
    # admin/courses#index => admin-courses_index
    controller = params[:controller].tr("/","-")
    action = params[:action]
    "#{controller}_#{action}"
  end

  def store_location(location = nil)
    location ||= request.fullpath
    session[:location] = location
  end

  def redirect_to_back_or_default(location = nil)
    if session[:location].present?
      redirect_to session.delete(:location)
    else
      redirect_to (location || root_path)
    end
  end

  def render_404(msg="Not Found")
    raise ActionController::RoutingError.new(msg)
  end

  # @params [String] msg
  # @params [ActiveModel::Errors | (Hash => String|Array<String>)] errors
  def render_400(msg,errors=nil)
    if errors.is_a?(ActiveModel::Errors)
      errors = errors.to_hash
    end

    if request.xhr?
      render json: {
        msg: msg,
        errors: errors
      }, status: :bad_request
    else
      render text: msg
    end
  end

  private

  def ensure_trailing_slash
    if (!trailing_slash?) && request.get?
      redirect_to url_for(params.merge(:trailing_slash => true)), :status => 301
    end
  end

  def trailing_slash?
    request.original_fullpath.match(/[^\?]+/).to_s.last == '/'
  end

  def tracker
    @tracker ||= Mixpanel::Tracker.new(ENV["MIXPANEL_TOKEN"])
  end

  def mixpanel_register(properties)
    if cookies.signed[:properties]
      origin_properties = JSON.parse(cookies.signed[:properties])
      new_properties = origin_properties.merge(properties)
      cookies.permanent.signed[:properties] = JSON.generate(new_properties)
    else
      cookies.permanent.signed[:properties] = JSON.generate(properties)
    end
  end

  def mixpanel_track(distinct_id, event, properties = nil)
    if properties
      new_properties = get_properties.merge(properties)
      MixpanelTrackJob.perform_later(distinct_id, event, new_properties)
    else
      MixpanelTrackJob.perform_later(distinct_id, event, get_properties)
    end
  end

  def mixpanel_alias(alias_id, real_id)
    tracker.alias(alias_id, real_id)
  end

  def get_properties
    if cookies.signed[:properties]
      return JSON.parse(cookies.signed[:properties])
    else
      return {}
    end
  end

end
