class Admin::EnrollmentsController < Admin::ApplicationController

  def index
    @enrollments = Enrollment.all
  end

  def send_invitation_email
    # content = params[:content]

    UserMailer.invitation_email(enrollment, "hello, click this invitation link: #{invite_enrollment_url(@enrollment)}").deliver_later
    enrollment.update_attribute :has_sent_invitation_email, true
    render text: "sent email"
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