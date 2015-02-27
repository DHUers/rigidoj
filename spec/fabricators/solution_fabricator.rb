Fabricator(:solution) do
  user_id { Fabricate(:user).id }
  problem_id { Fabricate(:problem).id }
  platform { SiteSetting.judger_platforms[0] }
  source 'source'
end

Fabricator(:accepted_solution, from: :solution) do
  status 3 # :accepted_answer
end
