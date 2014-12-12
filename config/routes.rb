Rails.application.routes.draw do
  resources :users, param: :username do
    resources :favroites
    resources :notes
    get '/solved_problems', to: 'users#solved_problems', as: :solved_problems
    get '/joined_contests', to: 'users#joined_contests', as: :joined_contests
  end

  resources :contests
  resources :posts
  resources :solutions
  resources :problems do
    resources :solutions
  end

  namespace :admin do
    get '/dashboard', to: 'admin#dashboard'
    scope :settings do
      get '/:category', to: 'admin#show_settings', as: :settings
      put '/:category', to: 'admin#update_settings'
    end

    root to: 'admin#dashboard'
  end

  namespace :settings do
    get '/profile', to: 'settings#profile', as: :profile
    root to: 'settings#profile'
  end

  get '/signup', to: 'users#new', as: :registration
  get '/login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout
  get '/about', to: 'statics#about', as: :about
  get '/help', to: 'statics#help', as: :help
  root to: 'statics#home'
end
