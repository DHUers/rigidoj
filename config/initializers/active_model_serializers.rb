ActiveModel::Serializer.setup do |config|
  config.adapter = :json_api
  config.embed = :ids
  config.embed_in_root = true
end
