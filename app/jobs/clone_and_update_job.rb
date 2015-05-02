class CloneAndUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(course)
    course.content_update
  end
end
