class EnrollmentsController < ApplicationController
  layout "enrollment", except: [:show]

  def create
    if params[:email].blank?
      render_400 "请输入你的邮箱"
      return
    end

    user = User.find_or_initialize_by(email: params[:email])
    if !user.save
      render_400 "申请失败", user.errors
      return
    end

    @enrollment = Enrollment.find_or_initialize_by user_id: user.id, course_id: course.id
    # already enrolled
    if !enrollment.new_record?
      head :ok
      return
    end

    # create new enrollment
    if !enrollment.save
      flash[:error] = enrollment.errors.values.flatten.to_s
      render_400 "申请失败", enrollment.errors
      return
    end

    if user.activated?
      UserMailer.invite(enrollment).deliver_later
      enrollment.update(invitation_sent_time: Time.now)
    else
      UserMailer.welcome(enrollment).deliver_later
      user.update(sent_welcome_email: Time.now.beginning_of_day)
    end

    head :ok

    if cookies.signed[:distinct_id]
      mixpanel_alias(enrollment.id, cookies.signed[:distinct_id])
      cookies.delete :distinct_id
    end

    mixpanel_track(enrollment.id, "Created Enrollment", {"Course" => enrollment.course.name})
  end

  def enroll
    @course_invite = CourseInvite.find_by(token: params[:id])
    if !@course_invite
      render_404
    end

    if current_user
      temp_enrollment = Enrollment.find_or_initialize_by user_id: current_user.id, course_id: @course_invite.course_id

      if temp_enrollment.activated?
        redirect_to course_path(temp_enrollment.course)
        return
      end

      if temp_enrollment.new_record?
        temp_enrollment.save!

        if cookies.signed[:distinct_id]
          mixpanel_alias(temp_enrollment.id, cookies.signed[:distinct_id])
          cookies.delete :distinct_id
        end
        mixpanel_track(temp_enrollment.id, "Created Enrollment", {"Course" => temp_enrollment.course.name})
      end
      temp_enrollment.update(start_time: @course_invite.start_time) if @course_invite.start_time
      temp_enrollment.update(partnership_name: @course_invite.partnership_name) if !@course_invite.partnership_name.blank?

      @course = @course_invite.course
      @user = current_user
      @enrollment = temp_enrollment

      mixpanel_track(@enrollment.id, "Visited Inviting Page", {"Course" => enrollment.course.name})

    else
      @enrollment = Enrollment.new course_id: @course_invite.course_id
      @course = @course_invite.course

      anonymous_track
    end

    render 'invite'
  end

  def apply
    enrollment
    @course = enrollment.course

    synchronize_user

    if current_user && current_user.activated?
      if !enrollment.invitation_sent_time # 对于已经激活的用户，进入本界面的邮件就算是邀请邮件
        enrollment.update(invitation_sent_time: Time.now)
      end
      redirect_to invite_enrollment_path(enrollment)
    end

    if current_user && enrollment.user.introduce_submit? &&enrollment.user.introduce_submit_enrollment != enrollment.token
      #处理用户申请课程后，正在等待审核的过程中，用户在此期间申请其他课程。
      send_time = rand(30..60).minutes
      AutoActivatedJob.set(wait: send_time).perform_later(enrollment)

    end
  end

  def invite
    synchronize_user

    if enrollment.activated?
      redirect_to course_path(enrollment.course)
      return
    end

    enrollment.update(start_time: Time.now.beginning_of_day)

    if current_user && current_user.personal_info &&user_info_completed?  #登陆之后, enrollment 的 user 才是真实的
      if enrollment.course.free?
        enrollment.activate!
        redirect_to course_path(enrollment.course)
      else
        redirect_to pay_enrollment_path(enrollment)
      end
    end

    @course = enrollment.course
    @user = enrollment.user

    mixpanel_track(enrollment.id, "Visited Inviting Page", {"Course" => @course.name})
  end

  def update
    redirect_path = nil
    if params[:partner]
      redirect_path = enroll_enrollment_path(id: params[:partner])
    else
      redirect_path = invite_enrollment_path(enrollment)
    end

    user = enrollment.user
    if user.name.blank?
      name = params[:user][:name]
      if name.present?
        user.update_attribute :name, name
      else
        flash[:error] = "请输入你的姓名~"
        redirect_to redirect_path
        return
      end
    end

    if params[:partner]
      if params[:partnership_account].blank?
        flash[:error] = "请输入您的个性地址"
        redirect_to redirect_path
        return
      else
        enrollment.update(:partnership_account => params[:partnership_account])
      end
    end

    enrollment.user.update_attribute :personal_info, params.require(:personal_info).permit(:blog_url, :occupation, :gender)

    if !user_info_completed?
      flash[:error] = "请输入完整信息~"
      redirect_to redirect_path
      return
    end

    if enrollment.course.free
      activate_course
      return
    end

    redirect_to pay_enrollment_path(@enrollment, partner: params[:partner])
  end

  def pay
    if !user_info_completed?
      if params[:partner]
        redirect_to enroll_enrollment_path(params[:partner])
      else
        redirect_to_invite
      end
      return
    end

    if enrollment.activated
      redirect_to course_path(@enrollment.course)
      return
    end

    @course = @enrollment.course

    mixpanel_track(@enrollment.id, "Visited Payment Page", {"Course" => @course.name})
  end

  # POST
  def finish
    enrollment.buddy_name = params[:buddy_name]
    enrollment.save
    activate_course

    charge = enrollment.user.personal_info["occupation"] == "学生" ? 490 : 790
    mixpanel_track(enrollment.id, "Finished Payment", {"Charge" => charge,
                                                       "Course" => enrollment.course.name})
  end

  def show
    enrollment
  end

  def info_update
    if !enrollment.partnership_name.blank? && params[:partnership_account].blank?
      render json: {success: false, message: "个性地址不能为空~"}
      return
    end
    enrollment.update(partnership_account: params[:partnership_account])
    enrollment.user.update(personal_info: params.require(:personal_info).permit(:blog_url, :occupation, :gender))
    render json: {success: true, url: course_path(enrollment.course)}
  end


  private

  class InvalidEnrollmentTokenError < RuntimeError ; end
  class InvalidPersonalInfoError < RuntimeError ; end

  def synchronize_user
    if current_user && enrollment.user != current_user
      old_user = enrollment.user
      enrollment.update_attribute :user, current_user

      #update introduce
      if current_user.introduce.blank? || current_user.introduce.length < old_user.introduce.length
        current_user.update(introduce: old_user.introduce)
      end
    end
  end

  def activate_course
    enrollment.activate!
    login_as enrollment.user
    redirect_to course_path(enrollment.course)
  end

  def user_info_completed?
    enrollment.user.has_binded_github && (!enrollment.user.personal_info["occupation"].blank?) && (!enrollment.user.personal_info["gender"].blank?)
  end

  def redirect_to_invite
    redirect_to invite_enrollment_path(@enrollment)
  end

  def course
    @course ||= Course.by_param!(params[:course_id])
  end

  def enrollment
    return @enrollment if defined?(@enrollment)
    @enrollment = Enrollment.find_by(token: params[:id])
    if @enrollment.nil? || (params[:token] && @enrollment.token != params[:token])
      raise InvalidEnrollmentTokenError
    else
      @enrollment
    end
  end

end
