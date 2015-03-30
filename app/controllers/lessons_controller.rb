class LessonsController < ApplicationController

  def show
    session[:user_id] = 1
    @lesson = {
                "name" => "Test"
              }

  end
end
