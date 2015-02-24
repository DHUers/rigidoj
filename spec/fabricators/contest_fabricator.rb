Fabricator(:contest) do
  title 'contest'
  description_raw 'contest raw'
  status 0
  started_at Time.now
  end_at 3.days.since
end