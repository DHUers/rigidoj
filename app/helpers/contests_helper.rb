module ContestsHelper
  def alphabet_offset(offset)
    ('A'.ord + offset).chr
  end

  def contest_problem_select_options(problems)
    @problem_options ||= problems.each_with_index.map do |p,i|
      ["#{alphabet_offset(i)}: #{p.title}", i]
    end
  end

  def contest_progress(contest)
    progress = (Time.now - contest.started_at).to_f /
        (contest.end_time - contest.started_at) * 100
    progress >= 100 ? 100 : progress
  end

end
