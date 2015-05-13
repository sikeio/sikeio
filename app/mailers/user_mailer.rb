class UserMailer < ApplicationMailer
  def welcome(enrollment)
    course_name = enrollment.course.name
    @user = enrollment.user

    titles = {
      "ios" => "【思客教学】 iOS 训练营邀请",
      "nodejs" => "【思客教学】 NodeJS 训练营邀请"
    }
    title = titles[course_name] || raise("no welcome email defiend for: #{course_name}")

    mail(to: @user.email, subject: title, template_name: "welcome_#{course_name}")
  end

  def invite(enrollment)
    titles = {
      # "ios" => "【思客教学】 iOS 训练营邀请",
      "nodejs" => "【思客教学】 NodeJS 训练营邀请",
      "css0to1" => "【思客教学】 CSS 从 0 到 1 迷你训练营邀请",
    }

    course_name = enrollment.course.name
    title = titles[course_name] || raise("no invite email defiend for: #{course_name}")

    @course = enrollment.course
    @enrollment = enrollment
    @next_monday = enrollment.next_monday
    @user = @enrollment.user

    mail \
      to: @user.email,
      subject: title,
      template_name: "invite_#{course_name}"

  end

end
