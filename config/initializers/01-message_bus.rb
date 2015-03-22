MessageBus.user_id_lookup do |env|
  request = Rack::Request.new(env)
  user_id = request.cookies['message_bus_user_id']
  user = User.exists?(id: user_id)
  user_id if user
end

MessageBus.redis_config = YAML.load(ERB.new(File.new("#{Rails.root}/config/redis.yml").read).result)[Rails.env].symbolize_keys
