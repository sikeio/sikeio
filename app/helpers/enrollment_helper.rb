module EnrollmentHelper

  def enrollment_valid?(enrollment)
    if enrollment.nil?
      flash[:error] = "您没有报名这个课程"
      return false
    elsif !enrollment.activated?
      flash[:error] = "您尚未激活该课程"
      return false
    else
      return true
    end
  end


end
