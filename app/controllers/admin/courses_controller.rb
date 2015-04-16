class Admin::CoursesController < Admin::ApplicationController

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    course_info = course_params
    course = Course.create(course_info)

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

  private

  def course_params
     params.require(:course).permit(:name, :repo_url, :current_version)
  end

  def course
    @course ||= Course.find_by(permalink: params[:id])
  end

end
