Rails.application.routes.draw do
  resource :users

  resources :contests
  resources :posts
  resources :solutions
  resources :problems do
    resources :solutions
  end

  get '/signup', to: 'users#new', as: :registration
  get '/login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout
  get '/about', to: 'statics#about', as: :about
  get '/help', to: 'statics#help', as: :help
  root 'statics#home'
end
