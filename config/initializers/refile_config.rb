Refile.types[:code] = Refile::Type.new(:code,
                                       content_type: %w[text/plain]
)

Refile.store = Refile::Backend::FileSystem.new(Rails.root.join("public/uploads").to_s)
