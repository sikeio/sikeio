class UsersController < ApplicationController
  layout "home", only: [:resume]

  before_action :require_login, only: [:update_personal_info, :update_resume]
  before_action :require_correct_user, only: [:update_personal_info]

  def notes
    get_user
     @send_day = Time.now.beginning_of_day.to_f * 1000 # convert to milliseconds for js
  end

  def update_resume
    company = params[:user][:company]
    resume_url = params[:user][:resume_url]
    if company.blank?
      flash[:error] = "请填写你希望内推的公司~"
      redirect_to resume_path
      return
    else
      current_user.update(company: company)
    end
    if resume_url.blank?
      flash[:error] = "请上传您的简历或填写您简历所在的网址~"
      redirect_to resume_path
      return
    else
      current_user.update(resume_url: resume_url)
    end
    redirect_to resume_path
  end

  def resume
    @show_info = {
      background:  "job.jpg",
      job: true,
      title: "思客 Pro 就业直通车"
    }
  end

  def introduce_update
    enrollment = Enrollment.find_by_token(params[:token])
    render_404 if !enrollment
    enrollment.user.update!(user_params)


    if !enrollment.user.introduce_submit? && enrollment.user.introduce.length > (92 + 10)
      send_time = rand(30..60).minutes
      AutoActivatedJob.set(wait: send_time).perform_later(enrollment)
    end

    if !enrollment.user.introduce_submit?
      enrollment.user.update(introduce_submit: true)
      enrollment.user.update(introduce_submit_enrollment: enrollment.token)
    end

    redirect_to apply_enrollment_path(enrollment)
  end

  def autosave
    enrollment = Enrollment.find_by_token(params[:token])
    if !enrollment
      render json: {msg: "注册信息不存在"}, status: :bad_request
    else
      enrollment.user.update!(user_params)
      head :ok
    end
  end

  def note
    get_user
    @checkin = @user.checkins.find params[:checkin].last
  end

  def update_personal_info
    get_user
    @user.update_attribute :personal_info, params.require(:personal_info).permit(:blog, :twitter, :intro)
    head :ok
  end

  private


  def user_params
    params.require(:user).permit(:name, :introduce)
  end

  def get_user
    return @user if defined? @user
    @user = User.find_by_github_username(params[:github_username])
    if @user.nil?
      if params[:github_username] == "$self$"
        if current_user
          @user = current_user
        else
          flash[:error] = "用户不存在~"
          redirect_to root_path
        end
      else
        if current_user
          flash.now[:error] = "用户不存在~"
          @user = current_user
        else
          flash[:error] = "用户不存在~"
          redirect_to root_path
        end
      end
    end
  end

  def require_correct_user
    get_user
    if current_user != @user
      raise "Incorrect user attempts to update personal info!"
    end
  end


end
