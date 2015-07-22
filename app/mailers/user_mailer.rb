class UserMailer < ApplicationMailer
  def index_welcome(email)
    title = "【思客教学】训练营"

    mail(to: email, subject: title, template_name: "index_welcome")

  end

  def welcome(enrollment)
    @course_name = enrollment.course.name
    @url = apply_enrollment_url(enrollment)

    titles = {
      "ios" => "【思客教学】 iOS 训练营",
      "nodejs" => "【思客教学】 NodeJS 训练营",
      "css0to1" => "【思客教学】 CSS 从 0 到 1 迷你训练营",
      "design101" => "【思客教学】 码农学设计训练营"
    }
    title = titles[@course_name] || raise("no welcome email defiend for: #{@course_name}")

    mail(to: enrollment.user.email, subject: title, template_name: "welcome")
  end

  def invite(enrollment)
    titles = {
      "ios" => "【思客教学】 iOS 训练营邀请",
      "nodejs" => "【思客教学】 NodeJS 训练营邀请",
      "css0to1" => "【思客教学】 CSS 从 0 到 1 迷你训练营邀请",
      "design101" => "【思客教学】 码农学设计训练营邀请"
    }

    @course_name = enrollment.course.name
    @url = invite_enrollment_url(enrollment)
    title = titles[@course_name] || raise("no invite email defiend for: #{@course_name}")


    mail \
      to: enrollment.user.email,
      subject: title,
      template_name: "invite"

  end

  def checkin_late(enrollment)
    titles = {
      # "ios" => "【思客教学】 iOS 训练营邀请",
      "nodejs" => "【思客教学】 NodeJS 训练营邀请",
      "css0to1" => "【思客教学】 CSS 从 0 到 1 迷你训练营邀请",
    }

    course_name = enrollment.course.name
    title = titles[course_name] || raise("no invite email defiend for: #{course_name}")
    @user = enrollment.user


    mail \
      to: @user.email,
      subject: title,
      template_name: "checkin_late"
  end

  def reinvite(enrollment)
    titles = {
      # "ios" => "【思客教学】 iOS 训练营邀请",
      "nodejs" => "【思客教学】 NodeJS 训练营邀请",
      "css0to1" => "【思客教学】 CSS 从 0 到 1 迷你训练营邀请",
    }

    course_name = enrollment.course.name
    title = titles[course_name] || raise("no invite email defiend for: #{course_name}")
    @user = enrollment.user


    mail \
      to: @user.email,
      subject: title,
      template_name: "reinvite"

  end

  def no_first_checkin(enrollment)
    titles = {
      # "ios" => "【思客教学】 iOS 训练营邀请",
      "nodejs" => "【思客教学】 NodeJS 训练营邀请",
      "css0to1" => "【思客教学】 CSS 从 0 到 1 迷你训练营邀请",
    }

    course_name = enrollment.course.name
    title = titles[course_name] || raise("no invite email defiend for: #{course_name}")
    @user = enrollment.user


    mail \
      to: @user.email,
      subject: title,
      template_name: "no_first_checkin"

  end

end
