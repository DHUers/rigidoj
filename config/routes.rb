Rails.application.routes.draw do
  resource :users

  resources :contests
  resources :posts
  resources :solutions
  resources :problems do
    resources :solutions
  end

  get '/about', to: 'statics#about', as: :about
  get '/help', to: 'statics#help', as: :help
  root 'statics#index'
end
