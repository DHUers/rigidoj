Rails.application.routes.draw do
  devise_for :users

  resources :problems
  resources :contests
  resources :posts

  get '/about', to: 'statics#about', as: :about
  get '/help', to: 'statics#help', as: :help
  root 'statics#index'
end
