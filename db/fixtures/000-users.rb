User.seed do |u|
  u.id    = -1
  u.email = 'no_email'
  u.username = 'System'
  u.name = 'System'
  u.password = SecureRandom.hex
  u.active = true
  u.admin = true
end
