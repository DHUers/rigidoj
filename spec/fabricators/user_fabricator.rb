Fabricator(:user) do
  name 'Erick 管'
  username { sequence(:username) { |i| "ffffff#{i}" } }
  email { sequence(:email) { |i| "ffffff#{i}@example.com" } }
  password 'myawesomepassword'
  active true
end

Fabricator(:erick) do
  name 'Eric管'
  username 'Eric管'
  email 'ff@ww.com'
  password 'myawesomepassword1'
end
