class AutoActivatedJob < ActiveJob::Base
  queue_as :default

  def perform(enrollment)
    enrollment.reload
    if !enrollment.user.activated?
      enrollment.user.update(activated: true)
    end

    if enrollment.invitation_sent_time.blank?
      UserMailer.invite(enrollment).deliver_later
      enrollment.update(invitation_sent_time: Time.now)
    end
  end
end
