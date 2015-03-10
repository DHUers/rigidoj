source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use Rails Html Sanitizer for HTML sanitization
gem 'rails-html-sanitizer', '~> 1.0'

gem 'refile', require: ['refile/rails', 'refile/image_processing'], git: 'https://github.com/refile/refile.git'

gem 'mini_magick'
gem 'rack-mini-profiler', require: false

gem 'pundit'
gem 'nokogiri'
gem 'sidekiq'
gem 'kaminari'
gem 'haml'
gem 'haml-rails'
gem 'message_bus'
gem 'pry-rails', require: false

gem 'bunny'
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']

gem 'seed-fu'
gem 'groupify'
gem 'active_model_serializers'
gem 'bcrypt'
gem 'sanitize'
gem 'fast_xor'
gem 'rmmseg-cpp', require: false
gem 'whenever', require: false
gem 'unicorn-rails', require: false
gem 'thin', require: false
gem 'stringex', require: false

gem 'gctools', require: false, platform: :mri_21
gem 'stackprof', require: false, platform: :mri_21
gem 'memory_profiler', require: false, platform: :mri_21

# frontend assets
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
gem 'font-awesome-rails'
gem 'jquery-ui-rails'
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'

group :development, :test do
  gem 'rspec-rails'
  gem 'codeclimate-test-reporter', require: nil
  gem 'spring'
  gem 'pry-nav'
  gem 'librarian'
end

group :development do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'web-console'
  gem 'better_errors'
  gem 'annotate'
end

group :test do
  gem 'fabrication'
  gem 'shoulda'
  gem 'timecop'
  gem 'fakeweb'
end

gem 'rack-reverse-proxy', require: 'rack/reverse_proxy'
