class LessonsController < ApplicationController
  layout "logined", except: [:info]

  before_action :require_login

  before_action :ensure_trailing_slash, :only => [:show]

  def show
    # schedule = @enrollment.schedule
    # @lesson = schedule.course_lesson(params[:lesson_permalink])
    # if Checkout.check_out?(@enrollment, @lesson)
    #   @checkout = @enrollment.checkouts.find_by(lesson_name: @lesson.name)
    # end
    if !enrollment_valid?(enrollment)
      redirect_to root_path(course: enrollment.course.permalink)
      return
    end

    lang = params[:lang]

    content = lesson.content
    # TODO should cache this
    @lesson_html = content.html_page(lang)
    @is_extra_lesson = !enrollment.schedule.is_course_lesson?(lesson)
    @is_checkout = Checkin.checkin?(enrollment, lesson)
    enrollment.update!(last_visit_time: Time.now)

    mixpanel_track(enrollment.id, "Visited Lesson Show Page", { "Course" => enrollment.course.name })
  end

  def ask
    BearychatMsgSenderJob.send_msg_to_all "#{current_user.github_username} 对 #{lesson.course.name} 的 #{lesson.title} 进行了[提问](#{lesson.discourse_qa_topic_url})"
    redirect_to lesson.discourse_qa_topic_url
  end

  private

  def lesson
    @lesson ||= course.lessons.find_by!(permalink: params[:id])
  end

  def enrollment
    @enrollment ||= current_user.enrollments.find_by(course: course)
  end

  def course
    @course ||= Course.by_param!(params[:course_id])
  end

end
