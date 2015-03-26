Rails.application.routes.draw do
  resources :users, param: :username do
    resources :notes
  end
  get '/users/:username/admin', to: 'users#grant_admin', as: :user_grant_admin
  get '/users/:username/moderator', to: 'users#grant_moderator', as: :user_grant_moderator
  get '/users/:username/block', to: 'users#block', as: :user_block
  post '/users/is_local_username', to: 'users#is_local_username'
  get '/users/search/users', to: 'users#search_users'

  resources :groups, param: :group_name

  resources :delayable_contests, controller: 'contests', type: 'DelayableContest', except: :show

  get '/contests', to: 'contests#index', as: :contests
  post '/contests', to: 'contests#create'
  get '/contests/new', to: 'contests#new', as: :new_contest
  get '/c/:slug/:id', to: 'contests#show', constraints: {id: /\d+/}, as: :contest
  get '/c/:slug/:id/edit', to: 'contests#edit', constraints: {id: /\d+/}, as: :edit_contest
  match '/c/:slug/:id', to: 'contests#update', constraints: {id: /\d+/}, via: [:patch, :put]
  delete '/c/:slug/:id', to: 'contests#destroy', constraints: {id: /\d+/}
  get 'c/:slug/:id/notifications/new', to: 'contests#new_notification', constraints: {id: /\d+/}, as: :new_contest_notification
  post 'c/:slug/:id/notifications', to: 'contests#create_notification', constraints: {id: /\d+/}, as: :contest_notifications
  get '/c/:slug/:id/ranking', to: 'contests#ranking', constraints: {id: /\d+/}, as: :contest_ranking
  get '/c/:slug/:contest_id/solutions', to: 'contests#solutions', constraints: {contest_id: /\d+/}, as: :contest_solutions
  post '/c/:slug/:contest_id/solutions', to: 'contests#create_solution', constraints: {contest_id: /\d+/}
  get '/c/:slug/:contest_id/posts', to: 'posts#index_with_contest', constraints: {contest_id: /\d+/}, as: :contest_posts
  post '/c/:slug/:contest_id/posts', to: 'posts#create_with_contest', constraints: {contest_id: /\d+/}
  get '/c/:slug/:contest_id/posts/new', to: 'posts#new_with_contest', constraints: {contest_id: /\d+/}, as: :new_contest_post
  get '/c/:slug/:contest_id/:post_id', to: 'posts#show_with_contest', constraints: {contest_id: /\d+/, post_id: /\d+/}, as: :contest_post

  resources :posts do
    put '/pinned', to: 'posts#toggle_pinned', as: :pinned
    put '/visible', to: 'posts#toggle_visible', as: :visible
    resources :comments
  end
  resources :solutions do
    get '/report', to: 'solutions#report'
  end
  get '/problems', to: 'problems#index', as: :problems
  post '/problems', to: 'problems#create'
  get '/problems/new', to: 'problems#new', as: :new_problem
  get '/p/:slug/:id', to: 'problems#show', constraints: {id: /\d+/}, as: :problem
  get '/p/:slug/:id/edit', to: 'problems#edit', constraints: {id: /\d+/}, as: :edit_problem
  match '/p/:slug/:id', to: 'problems#update', constraints: {id: /\d+/}, via: [:patch, :put]
  delete '/p/:slug/:id', to: 'problems#destroy', constraints: {id: /\d+/}
  post '/problems/import', to: 'problems#import', as: :problems_import
  get '/problems/:id/excerpt', to: 'problems#excerpt'
  get '/p/:slug/:problem_id/solutions', to: 'problems#solutions', constraints: { problem_id: /\d+/ }, as: :problem_solutions
  post '/p/:slug/:problem_id/solutions', to: 'problems#create_solution', constraints: { problem_id: /\d+/ }

  namespace :admin do
    get '/dashboard', to: 'admin#dashboard'
    scope :settings do
      get '/:category', to: 'admin#show_settings', as: :settings
      put '/:category', to: 'admin#update_settings'
    end
    get '/groups', to: 'admin#groups', as: :groups
    post '/groups', to: 'admin#create_group'
    get '/groups/:group_name', to: 'admin#group', as: :group
    put '/groups/:group_name', to: 'admin#update_group'
    get '/uploads', to: 'admin#uploads_index', as: :uploads

    root to: 'admin#dashboard'
  end

  resources :uploads

  post '/preview/text', to: 'preview#preview_text', as: :preview_text
  post '/preview/code', to: 'preview#preview_code', as: :preview_code

  get '/settings/profile', to: 'user_settings#profile', as: :settings_profile
  post '/settings/profile', to: 'user_settings#update_profile'
  get '/settings/account', to: 'user_settings#account', as: :settings_account
  post '/settings/account', to: 'user_settings#update_account'
  post '/settings/email', to: 'user_settings#update_email', as: :settings_email
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
