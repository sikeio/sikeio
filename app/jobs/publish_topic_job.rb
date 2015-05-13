class PublishTopicJob < ActiveJob::Base
  queue_as :default

  def perform(checkin)
    checkin.publish
  end
end
