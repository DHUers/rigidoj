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

gem 'carrierwave'

gem 'mini_magick'
gem 'rack-mini-profiler', require: false

gem 'pundit'
gem 'nokogiri'
gem 'sidekiq'
gem 'kaminari'
gem 'haml'
gem 'haml-rails'
gem 'message_bus'

gem 'bunny'
gem 'msgpack'
gem 'hiredis'
gem 'redis-store'
gem 'redis', require: ['redis', 'redis/connection/hiredis']

gem 'seed-fu', git: 'https://github.com/SamSaffron/seed-fu.git', branch: 'discourse'

gem 'active_model_serializers'
gem 'bcrypt'
gem 'sanitize'
gem 'fast_xor'
gem 'fog', require: false
gem 'rmmseg-cpp', require: false
gem 'composite_primary_keys', '~> 8.0.0'
gem 'whenever', require: false
gem 'unicorn-rails'

# frontend assets
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
gem 'font-awesome-rails'
gem 'jquery-ui-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'codeclimate-test-reporter', require: nil
  gem 'spring'
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
