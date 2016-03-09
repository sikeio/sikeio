class AdminConstraint
  def matches?(request)
    return request.session[:is_admin] == true
  end
end

Rails.application.routes.draw do
  get '/sso/new'
  get '/sso/succeed'

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/admin/sidekiq', :constraints => AdminConstraint.new

  root 'home#index'


  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/test/:id' => 'courses#test'

  post '/checkin/:id' => 'checkins#create', as: :checkin
  put '/checkin/:id' => 'checkins#update', as: :checkin_update
  get '/checkin/:id' => 'checkins#show', as: :checkin_show


  resources :subscribers, only: [:create]

  get '/@:github_username' => 'users#notes', as: :user_notes
  get '/@:github_username/:checkin' => 'users#note', as: :user_note
  post '/@:github_username' => 'users#update_personal_info', as: :update_user

  post '/users/autosave' => 'users#autosave', as: :autosave
  patch '/users/resume' => 'users#update_resume', as: :update_resume
  get '/users/resume' => 'users#resume', as: :resume
  patch '/users/update' => 'users#introduce_update', as: :update_introduce

  resources :users,only:[:show] do
    member do
      get '/activation' => 'users#activation'
      post '/activation' => 'users#activate'
    end
  end

  resources :courses,only:[:show] do

  end

  get "/courses/:course_id/:id" => "lessons#show", as: :lesson

  get "/courses/:course_id/:id/ask" => "lessons#ask", as: :lesson_ask


  resources :enrollments, only: [:create,:update, :new, :show] do
    member do
      get 'enroll'
      get 'invite'
      get 'pay'
      post 'finish'
      patch 'info_update'
      get 'apply'
    end
  end


  get '/auth/:provider/callback' => 'authentications#callback'
  get '/auth/failure' => 'authentications#fail'

  scope 'api',format: :json do
    get 'login_status' => 'api#login_status'
  end

  scope 'qiniu',format: :json do
    get 'uptoken' => 'qiniu#uptoken'
  end


  namespace 'admin' do
    get '/' => "dashboard#index", as: :dashboard
    get "status" => "dashboard#status"

    get "/recent_enrollments" => "dashboard#recent_enrollments"

    post "login_as_user/:user_id" => "dashboard#login_as_user", as: :login_as_user

    # controller :dashboard do


    # end
    # post "/login_as_user/:user_id" => "dashboard#login_as_user", as: :login_as_user

    get '/login' => "sessions#new"
    post '/login' => "sessions#create"
    delete '/logout' => 'sessions#destroy'
    delete '/invite_delete/:id' => 'courses#delete_invite' , as: :invite_delete
    post '/start_time/:id' => 'courses#start_at_this_week', as: :start_time
    post '/delete_start_time/:id' => 'courses#delete_start_time' , as: :delete_start_time
    get '/reminder_enrollments/:id' => 'courses#reminder_enrollments', as: :reminder_enrollments

    namespace :test do
      post :send_email
      get :show_flash
    end

    resources :users,only:[:index] do
      post :login
    end

    resources :enrollments,only:[:index] do
      member do
        post 'send_invitation_email'
        post 'set_payment_status'
        post 'send_welcome_email'
      end
    end

    resources :courses do
      member do
        post 'create_invite'
        get :info
        post 'clone_and_update' => 'courses#clone_and_update'
        post 'generate_discourse_topics'
      end
    end
  end
end


