require 'mixpanel-ruby'

class MixpanelTrackJob < ActiveJob::Base
  queue_as :default

  def perform(id, event, properties)
    tracker = Mixpanel::Tracker.new(ENV["MIXPANEL_TOKEN"])
    tracker.track(id, event, properties)
  end
end
