MessageBus.redis_config = YAML.load(ERB.new(File.new("#{Rails.root}/config/redis.yml").read).result)[Rails.env].symbolize_keys
