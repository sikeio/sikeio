class CloneAndUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(course)
    updater = Course::Updater.new(course)
    updater.update
  end
end
