Refile.types[:code] = Refile::Type.new(:code,
                                       content_type: %w[text/plain application/octet-stream]
)
Refile.secret_key = SecureRandom.hex(64).to_s
