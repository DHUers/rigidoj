Fabricator(:user) do
  name 'Erick 管'
  username {sequence(:username) {|i| "user#{i}"}}
  email {sequence(:email) {|i| "user#{i}@example.com"}}
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

Fabricator(:moderator, from: :user) do
  moderator true
end

Fabricator(:admin, from: :user) do
  admin true
end
