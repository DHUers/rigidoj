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

  resources :delayable_contests, controller: 'contests', type: 'DelayableContest', except: :show

  get '/contests', to: 'contests#index', as: :contests
  post '/contests', to: 'contests#create'
  get '/contests/new', to: 'contests#new', as: :new_contest
  get '/c/:slug/:id', to: 'contests#show', constraints: {id: /\d+/}, as: :contest
  get '/c/:slug/:id/edit', to: 'contests#edit', constraints: {id: /\d+/}, as: :edit_contest
  match '/c/:slug/:id', to: 'contests#update', constraints: {id: /\d+/}, via: [:patch, :put]
  delete '/c/:slug/:id', to: 'contests#destroy', constraints: {id: /\d+/}
  get '/c/:slug/:id/ranking', to: 'contests#ranking', constraints: {id: /\d+/}, as: :contest_ranking
  get '/c/:slug/:contest_id/solutions', to: 'solutions#index', constraints: {contest_id: /\d+/}, as: :contest_solutions
  post '/c/:slug/:contest_id/solutions', to: 'solutions#create', constraints: {contest_id: /\d+/}

  resources :posts
  resources :solutions
  get '/problems', to: 'problems#index', as: :problems
  post '/problems', to: 'problems#create'
  get '/problems/new', to: 'problems#new', as: :new_problem
  get '/p/:slug/:id', to: 'problems#show', constraints: {id: /\d+/}, as: :problem
  get '/p/:slug/:id/edit', to: 'problems#edit', constraints: {id: /\d+/}, as: :edit_problem
  match '/p/:slug/:id', to: 'problems#update', constraints: {id: /\d+/}, via: [:patch, :put]
  delete '/p/:slug/:id', to: 'problems#destroy', constraints: {id: /\d+/}
  post '/problems/import', to: 'problems#import'
  get '/problems/:id/excerpt', to: 'problems#excerpt'
  get '/p/:slug/:problem_id/solutions', to: 'solutions#index', constraints: {problem_id: /\d+/}, as: :problem_solutions

  namespace :admin do
    get '/dashboard', to: 'admin#dashboard'
    scope :settings do
      get '/:category', to: 'admin#show_settings', as: :settings
      put '/:category', to: 'admin#update_settings'
    end
    get '/groups', to: 'admin#groups', as: :groups
    get '/groups/:group_name', to: 'admin#group', as: :group

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
  post '/notifications/read', to: 'notifications#read'

  get '/rabbitmq', to: 'proxies#rabbitmq'

  root to: 'statics#home'
end
