Rails.application.routes.draw do
  resource :users

  resources :contests
  resources :posts
  resources :solutions
  resources :problems do
    resources :solutions
  end

  get '/signup', to: 'users#new', as: :user_registration
  get '/login', to: 'sessions#new', as: :login
  get '/about', to: 'statics#about', as: :about
  get '/help', to: 'statics#help', as: :help
  root 'statics#home'
end
