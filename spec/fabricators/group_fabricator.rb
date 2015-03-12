Fabricator(:group) do
  group_name { sequence(:group_name) { |i| "group_name#{i}" } }
  name { sequence(:name) { |i| "name#{i}"} }
  visible true
end
