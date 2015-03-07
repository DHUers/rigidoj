# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'rack/reverse_proxy'

use Rack::ReverseProxy do
  reverse_proxy /^\/rabbitmq(\/.*)$/, "http://#{ENV['RIGIDOJ_RABBITMQ_HOST']}:15672$1", username: ENV['RIGIDOJ_RABBITMQ_USERNAME'], password: ENV['RIGIDOJ_RABBITMQ_PASSWORD'], timeout: 500, preserve_host: true
end

map Rigidoj::Application.config.relative_url_root || "/" do
  run Rails.application
end
