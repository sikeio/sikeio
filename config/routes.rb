Rails.application.routes.draw do

  root 'home#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/test/:id' => 'courses#test'

  post '/checkout/:enroll_id/:lesson_id' => 'checkouts#new', as: :check_out

  resources :subscribers,only:[:create]

  resources :users,only:[:show] do
    member do
      get '/activation' => 'users#activation'
      post '/activation' => 'users#activate'
      get '/' => 'users#dashboard',as: :dashboard
    end
  end

  resources :courses,only:[:index,:show] do

    member do

      get '/payment' => 'courses#payment'
      get '/start' => 'courses#start'
    end

    collection do
      #list courses,user will select one to visit payment page
      post '/enroll' => 'courses#create_enroll'
      get '/list' => 'courses#list'
      get '/get_user_status' => 'courses#get_user_status'
    end
  end


  get '/auth/:provider/callback' => 'authentications#callback'


  namespace 'admin' do

    resources :users,only:[:index] do
      collection do
        post '/send_activation_email' => 'users#send_activation_email'
      end
    end

    get '/' => "dashboard#index",as: :dashboard

    get '/login' => "sessions#new"
    post '/login' => "sessions#create"
    delete '/logout' => 'sessions#destroy'
  end



end


