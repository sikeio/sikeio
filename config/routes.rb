Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/test/:id' => 'courses#test'

  get '/lessons/:course_permalink/:lesson_permalink' => 'lessons#show', as: :lesson

  post '/checkout/:course_permalink/:lesson_permalink' => 'checkouts#new', as: :check_out
  put '/checkout/:id' => 'checkouts#update', as: :check_out_update

  resources :subscribers,only:[:create]

  resources :users,only:[:show] do
    member do
      get '/activation' => 'users#activation'
      post '/activation' => 'users#activate'
      get '/' => 'users#dashboard',as: :dashboard
    end
  end

  resources :enrollments

  resources :courses,only:[:index,:show] do

    member do
      get 'start'
      get 'info'
    end

    collection do
      # get '/get_user_status' => 'courses#get_user_status'
    end
  end

  resources :enrollments,only: [:create] do
    member do
      get 'invite'
      get 'pay'
      post 'pay'
    end
  end


  get '/auth/:provider/callback' => 'authentications#callback'

  scope 'api',format: :json do
    get 'login_status' => 'api#login_status'
  end


  namespace 'admin' do
    get '/' => "dashboard#index",as: :dashboard

    get '/login' => "sessions#new"
    post '/login' => "sessions#create"
    delete '/logout' => 'sessions#destroy'

    namespace :test do
      post :send_email
    end

    resources :users,only:[:index] do
    end

    resources :enrollments,only:[:index] do
      member do
        post 'send_invitation_email'
        post 'set_payment_status'
      end
    end

    resources :courses do
      member do
        get :info
        post 'clone_and_update' => 'courses#clone_and_update'
      end
    end
  end
end


