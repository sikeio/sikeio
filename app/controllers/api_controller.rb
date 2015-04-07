class ApiController < ApplicationController

  def login_status
    if current_user
      render json:{login:  true}
    else
      render json:{login: false}
    end
  end

end