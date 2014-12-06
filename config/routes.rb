Rails.application.routes.draw do
  resource :users

  resources :contests
  resources :posts
  resources :solutions
  resources :problems do
    resources :solutions
  end

  namespace :admin do
    get '/', to: 'admin#dashboard'
    get '/dashboard', to: 'admin#dashboard'
    get '/settings', to: 'admin#required'
    get '/settings/required', to: 'admin#required'
    get '/settings/general', to: 'admin#general'

    root to: 'admin#dashboard'
  end

  get '/signup', to: 'users#new', as: :registration
  get '/login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout
  get '/about', to: 'statics#about', as: :about
  get '/help', to: 'statics#help', as: :help
  root to: 'statics#home'
end
