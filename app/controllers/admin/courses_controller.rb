class Admin::CoursesController < Admin::ApplicationController

  def new
    @course = Course.new
  end

  def create
    @course = Course.create(params.require(:course).permit(:name))
    if @course.valid?
      redirect_to edit_admin_course_path(@course)
    else
      render :new
    end
  end

  def update
    course.update_attributes(params.require(:course).permit(:name))
    if course.valid?
      redirect_to edit_admin_course_path(course)
    else
      render :edit
    end
  end

  def edit
    course
  end

  private

  def course
    @course ||= Course.find_by(name: params[:id])
  end

end