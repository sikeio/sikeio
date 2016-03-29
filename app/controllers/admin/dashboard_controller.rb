class Admin::DashboardController < Admin::ApplicationController

  def index
    @courses = Course.all
  end

  def status
    @head_commit = `git log -n 1`.strip
    @env = ENV
  end

  def recent_enrollments
    sql = <<HERE
with checkin_counts as (
  select enrollment_id, count(*) as count from checkins
  group by enrollment_id
  order by enrollment_id desc
  limit 100
)

select

checkin_counts.count,
users.email,
discourse_username,
users.id as user_id,
courses.title,
enrollments.created_at,
enrollment_id,
authentications.info->'info'->'nickname' as github_user

from checkin_counts
inner join enrollments on checkin_counts.enrollment_id = enrollments.id
inner join users on enrollments.user_id = users.id
inner join courses on enrollments.course_id = courses.id
inner join authentications on users.id =  authentications.user_id
order by enrollment_id desc
HERE
    # select info->'info'->'nickname' as github_user from authentications limit 10;

    @enrollments = ActiveRecord::Base.connection.execute(sql)

    # render json: @enrollments
  end

  def login_as_user
    user = User.find(params[:user_id])
    session[:user_id] = user.id
    cookies[:user_id] = user.id

    redirect_to root_path
  end


end