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
  get '/problems/:id/excerpt', to: 'problems#excerpt'

  namespace :admin do
    get '/dashboard', to: 'admin#dashboard'
    scope :settings do
      get '/:category', to: 'admin#show_settings', as: :settings
      put '/:category', to: 'admin#update_settings'
    end

    root to: 'admin#dashboard'
  end

  post '/preview/problems', to: 'preview#problem', as: :preview_problem
  post '/preview/solutions', to: 'preview#solution', as: :preview_solution

  get '/settings', to: redirect('/settings/profile'), as: :settings_root
  get '/settings/profile', to: 'user_settings#profile', as: :settings_profile
  post '/settings/profile', to: 'user_settings#update_profile'
  get '/settings/account', to: 'user_settings#account', as: :settings_account
  post '/settings/account', to: 'user_settings#update_account'
  get '/settings/notifications', to: 'user_settings#notification', as: :settings_notification
  post '/settings/notifications', to: 'user_settings#update_notification'

  get '/signup', to: 'users#new', as: :registration
  get '/login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout
  get '/about', to: 'statics#about', as: :about
  get '/help', to: 'statics#help', as: :help

  get 'search', to: 'search#query'

  root to: 'statics#home'
end
