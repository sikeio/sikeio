class Admin::EnrollmentsController < Admin::ApplicationController

  def index
    @enrollments = Enrollment.all
  end

  def send_invitation_email
    enrollment = Enrollment.find params[:id]
    content = params[:content]
    UserMailer.invitation_email(enrollment, content).deliver_later
    enrollment.data['has_sent_invitation_email'] = true
    enrollment.save
    head :ok
  end

end