Refile.types[:code] = Refile::Type.new(:code,
                                       content_type: %w[text/plain]
)
Refile.secret_key = GlobalSetting.refile_token || SecureRandom.hex(64).to_s

Refile.store = Refile::Backend::FileSystem.new(Rails.root.join("public/uploads").to_s)
