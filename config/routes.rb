Rails.application.routes.draw do

  root 'home#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/test/:id' => 'courses#test'

  post '/checkout/:enroll_id/:lesson_id' => 'checkouts#new', as: :check_out

  resources :lessons, only:[:show]
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
      get :info
      post :enroll
      get :invite
      get :pay
      post :pay
    end

    collection do
      # get '/get_user_status' => 'courses#get_user_status'
    end
  end


  get '/auth/:provider/callback' => 'authentications#callback'


  namespace 'admin' do

    resources :users,only:[:index] do
      collection do
        post '/send_activation_email' => 'users#send_activation_email'
      end
    end

    resources :courses

    get '/' => "dashboard#index",as: :dashboard

    get '/login' => "sessions#new"
    post '/login' => "sessions#create"
    delete '/logout' => 'sessions#destroy'
  end
end


