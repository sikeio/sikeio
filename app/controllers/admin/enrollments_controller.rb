class Admin::EnrollmentsController < Admin::ApplicationController

  def index
    @enrollments = Enrollment.all
  end

  def send_invitation_email
    content = params[:content]
    UserMailer.invitation_email(enrollment, content).deliver_later
    enrollment.update_attribute :has_sent_invitation_email, true
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