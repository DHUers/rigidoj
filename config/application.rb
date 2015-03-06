require File.expand_path('../boot', __FILE__)
require 'rails/all'

require_relative '../app/models/global_setting'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rigidoj
  class Application < Rails::Application
    def config.database_configuration
      if Rails.env.production?
        GlobalSetting.database_config
      else
        super
      end
    end

    require 'rigidoj'
    require 'rigidoj_redis'
    # Use redis for our cache
    config.cache_store = RigidojRedis.new_redis_store
    $redis = RigidojRedis.new

    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.middleware.delete Rack::Lock

    config.active_job.queue_adapter = :sidekiq

    config.active_record.schema_format = :sql
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths << Rails.root.join('lib')


    config.pbkdf2_iterations = 64000
    config.pbkdf2_algorithm = 'sha256'

  end
end
