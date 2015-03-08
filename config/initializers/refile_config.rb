Refile.types[:code] = Refile::Type.new(:code,
                                       content_type: %w[text/plain application/octet-stream]
)
puts GlobalSetting.refile_token
Refile.secret_key = GlobalSetting.refile_token || SecureRandom.hex(64).to_s
