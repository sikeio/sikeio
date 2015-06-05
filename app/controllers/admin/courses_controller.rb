class Admin::CoursesController < Admin::ApplicationController

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def show
    course
  end

  def reminder_enrollments
    @enrollments = Enrollment.reminder_needed(course)
  end

  def start_at_this_week
    if course_invite
      course_invite.start_at_this_week
      redirect_to admin_course_path(course_invite.course)
      return
    else
      redirect_to admin_course_path(course_invite.cousre)
      return
    end
  end

  def delete_start_time
    if course_invite
      course_invite.update(start_time: nil)
    end
    redirect_to admin_course_path(course_invite.course)
  end

  def delete_invite
    if course_invite
      temp_course = course_invite.course
      course_invite.destroy
      redirect_to admin_course_path(temp_course)
      return
    else
      redirect_to admin_courses_path
      return
    end
  end

  def create_invite
    invite = CourseInvite.new(course_id: course.id)
    if !invite.save
      flash[:error] = invite.errors
    end
    redirect_to admin_course_path(course)
  end

  def create
    course_info = course_params
    # create a course with temporarily generated permalink
    course = Course.create(course_info.merge(:permalink => SecureRandom.hex))

    redirect_to admin_courses_path
  end

  def update
    course.update_attributes(course_params)
    redirect_to admin_courses_path(course)
  end

  def edit
    course
  end

  def clone_and_update
    course = Course.find_by_permalink(params[:id])
    CloneAndUpdateJob.perform_later(course)
    redirect_to admin_courses_path
  end

  def generate_discourse_topics
    course.generate_discourse_topics
  end

  private

  def course_invite
    @course_invite ||= CourseInvite.find_by(id: params[:id])
  end

  def course_params
     params.require(:course).permit(:name, :repo_url, :current_version, :free, :color)
  end

  def course
    @course ||= Course.find_by(permalink: params[:id])
  end

end
