Fabricator(:user) do
  name 'Erick 管'
  username { sequence(:username) { |i| "ffffff#{i}" } }
  email { sequence(:email) { |i| "ffffff#{i}@example.com" } }
  password 'myawesomepassword'
  active true
end

Fabricator(:erick, from: :user) do
  name 'Eric管'
  username 'erick'
  email 'ff@ww.com'
  password 'Wpassword1'
  active true
end
