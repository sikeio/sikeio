class Admin::EnrollmentsController < Admin::ApplicationController

  def index
    @enrollments = Enrollment.all
  end

  def send_invitation_email
    UserMailer.invite(enrollment).deliver_later
    enrollment.update(invitation_sent_time: Time.now)
    head :ok
  end

  def send_welcome_email
    UserMailer.welcome(enrollment).deliver_later
    head :ok
  end

  def set_payment_status
    enrollment.update_attribute :paid,true
    head :ok
  end

  private
  def enrollment
    @enrollment ||= Enrollment.find_by!(token: params[:id])
  end

end
