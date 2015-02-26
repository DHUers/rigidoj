Fabricator(:contest) do
  title {sequence(:title) {|i| "title#{i}"}}
  description_raw 'contest raw'
  started_at '2099-01-01 00:00'
  end_at '2099-01-03 03:00'
  problems {3.times.map {Fabricate(:problem)}}
end

Fabricator(:frozen_contest, from: :contest) do
  frozen_ranking_from '2099-01-02 02:00'
end
