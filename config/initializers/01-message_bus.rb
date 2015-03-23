MessageBus.user_id_lookup do |env|
  user = CurrentUser.lookup_from_env(env)
  user.id if user
end

MessageBus.is_admin_lookup do |env|
  user = CurrentUser.lookup_from_env(env)
  user && user.admin ? true : false
end


MessageBus.redis_config = YAML.load(ERB.new(File.new("#{Rails.root}/config/redis.yml").read).result)[Rails.env].symbolize_keys
MessageBus.long_polling_interval = 30000

MessageBus.cache_assets = !Rails.env.development?
MessageBus.enable_diagnostics
