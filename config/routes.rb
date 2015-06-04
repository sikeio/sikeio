class AdminConstraint
  def matches?(request)
    return request.session[:is_admin] == true
  end
end

Rails.application.routes.draw do
  get '/sso/new'
  get '/sso/succeed'

  require 'sidekiq/web'
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

  resources :users,only:[:show] do
    member do
      get '/activation' => 'users#activation'
      post '/activation' => 'users#activate'
    end
  end

  resources :courses,only:[:index,:show] do

    member do
      get 'start'
      get 'info'
    end

    collection do
      # get '/get_user_status' => 'courses#get_user_status'
    end


  end

  get "/courses/:course_id/:id" => "lessons#show", as: :lesson


  resources :enrollments, only: [:create,:update, :new] do
    member do
      get 'enroll'
      get 'invite'
      get 'pay'
      post 'finish'
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

    get '/login' => "sessions#new"
    post '/login' => "sessions#create"
    delete '/logout' => 'sessions#destroy'
    delete '/invite_delete/:id' => 'courses#delete_invite' , as: :invite_delete
    post '/start_time/:id' => 'courses#start_at_this_week', as: :start_time
    post '/delete_start_time/:id' => 'courses#delete_start_time' , as: :delete_start_time

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


