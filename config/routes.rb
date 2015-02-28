Rails.application.routes.draw do
  resources :users, param: :username do
    resources :notes
    get '/solved_problems', to: 'users#solved_problems', as: :solved_problems
    get '/joined_contests', to: 'users#joined_contests', as: :joined_contests
  end
  get '/users/:username/bookmarks', to: 'bookmarks#person'
  get '/users/:username/groups', to: 'groups#person'
  post '/users/is_local_username', to: 'users#is_local_username'

  resources :groups, param: :name

  resources :contests, except: :show
  resources :delayable_contests, controller: 'contests', type: 'DelayableContest', except: :show

  get '/c/:slug/:id', to: 'contests#show', constraints: {id: /\d+/}, as: :show_contest
  get '/c/:slug/:id/ranking', to: 'contests#ranking', constraints: {id: /\d+/}, as: :contest_ranking
  get '/c/:slug/:contest_id/solutions', to: 'solutions#index', constraints: {contest_id: /\d+/}, as: :contest_solutions
  post '/c/:slug/:contest_id/solutions', to: 'solutions#create', constraints: {contest_id: /\d+/}
  resources :posts
  resources :solutions
  resources :problems, except: :show do
    resources :solutions
  end
  get '/p/:slug/:id', to: 'problems#show', constraints: {id: /\d+/}, as: :show_problem
  post '/problems/import', to: 'problems#import'
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

  get '/query', to: 'search#query'
  get '/notifications', to: 'notifications#recent'

  root to: 'statics#home'
end
