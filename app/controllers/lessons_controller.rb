class LessonsController < ApplicationController

  before_action :require_login

  def show
    # schedule = @enrollment.schedule
    # @lesson = schedule.course_lesson(params[:lesson_permalink])
    # if Checkout.check_out?(@enrollment, @lesson)
    #   @checkout = @enrollment.checkouts.find_by(lesson_name: @lesson.name)
    # end
    content = lesson.content
    # TODO should cache this
    @lesson_html = content.html_page
    @is_extra_lesson = !enrollment.schedule.is_course_lesson?(lesson)
    @is_checkout = Checkin.checkin?(enrollment, lesson)

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
