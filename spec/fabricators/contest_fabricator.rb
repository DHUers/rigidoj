Fabricator(:contest) do
  title { sequence(:title) { |i| "title#{i}" } }
  description_raw 'contest raw'
  started_at '2099-01-01 00:00'
  end_at '2099-01-03 00:00'
  problems { 4.times.map { Fabricate(:problem) } }
  users { 3.times.map { Fabricate(:user) } }
end

Fabricator(:frozen_contest, from: :contest) do
  frozen_ranking_from '2099-01-02 00:00'
end

Fabricator(:invisible_contest, from: :contest) do
  groups { 2.times.map { Fabricate :group } }
end
