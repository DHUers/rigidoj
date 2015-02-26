class ContestRanking
  PENALTY_TIME = 20

  # Required parameters
  # - operator:
  def initialize(operator, contest, users, opts = nil)
    @operator = operator
    @contest = contest
    @users = users
    @now = Time.now
    @opts = opts || {}
  end

  # rank
  # 1. accepted solution count
  # 2. time usage
  # 3. last accepted time

  # Generate status information for a user
  # Return format:
  #   1. Accepted submissions count
  #   2. Time usage, time usage spent on every accepted submission including penalty
  #   3. Problem list
  #     1. tries, including accepted submission
  #     2. time, accepted submssion time. blank if the solution isn't accepted
  #   4. Total submissions count
  def user_status(user_id)
    solutions = Solution.where(contest: @contest, user_id: user_id).reorder(created_at: 'ASC')
    total_solutions_count = solutions.count
    accepted_solutions_count = solutions.where(status: Solution.statuses['accept_answer']).count

    # separate the solutions by problem id
    filtered = Hash[solutions.group_by(&:problem_id).map method(:filter_solutions)]

    [user_id, filtered_result(accepted_solutions_count, total_solutions_count, filtered)]
  end

  def filtered_result(accepted, total, filtered)
    time = filtered.inject(0) {|acc,m| acc + m[1][0] ? m[1][2] : 0}
    problems = filtered.map {|_,v| v.drop(v[0] ? 2 : 1)}

    [accepted, time, problems, total]
  end

  # Filter and parse the accepted solution. If no solutions were selected,
  # leave it as is.
  # Require the solutions exist and are ordered by created time ASC
  # Doesn't care about the frozen status.
  # Two circumstances:
  # - accepted solution exists
  # - no accepted solution
  def filter_solutions(problem_id, solutions)
    # count solutions for comparing the filtered solutions
    count = solutions.count
    failed_attempts = solutions.take_while {|s| s.status != 'accepted_answer'}
    fails = failed_attempts.count
    if (is_accepted = fails < count)
      accpeted_solution = solutions[fails]
      time_usage = duration_in_minute(accpeted_solution.created_at) +
          PENALTY_TIME * fails.count
      [problem_id, [is_accepted, fails + 1, time_usage]]
    else
      [problem_id, [is_accepted, fails]]
    end
  end

  def frozen_status?(user_id)
    # we don't freeze the status to the op
    return false if user_id == @operator.id || @operator.staff?
    return false if @opts[:skip_frozen] || end_at.past?
    frozen_at ? frozen_at.past? : false
  end

  def duration_in_minute(time)
    (time - start_at).to_i / 60
  end

  private

  def problem_ids
    @problem_ids ||= @contest.problem_ids
  end

  def start_at
    @start_at ||= @contest.start_at
  end

  def frozen_at
    @frozen_at ||= @contest.frozen_ranking_from
  end

  def end_at
    @end_at = @contest.end_at
  end
end
