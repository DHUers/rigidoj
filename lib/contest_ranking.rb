class ContestRanking
  PENALTY_TIME = 20

  def self.rank(operator, contest, opts = nil)
    ContestRanking.new(operator, contest, opts).execute
  end

  # Required parameters
  # - operator:
  def initialize(operator, contest, opts = nil)
    @operator = operator
    @contest = contest
    @opts = opts || {}
  end

  def execute
    Hash[sorted]
  end

  # sorted
  # 1. accepted solution count
  # 2. time usage
  # 3. last accepted time
  # 4. name, user_ids is already sorted
  def sorted
    statuses = @contest.user_ids.map { |i| [i, user_status(i)] }
    statuses.sort! do |a,b|
      accpeted = a[1][0] <=> b[1][0]
      if accpeted == 0
        accpeted
      else
        time_usage = a[1][2] <=> b[1][2]
        time_usage == 0 ? a[1][3] <=> b[1][3] : time_usage
      end
    end
  end

  # Generate status information for a user
  # Return format:
  #   1. Solved problems count
  #   2. Time usage, time usage spent on every accepted submission including penalty
  #   3. Tried problems count
  #   4. Problem list
  #     1. tries, including accepted submission
  #     2. time, accepted submssion time. blank if the solution isn't accepted
  def user_status(user_id)
    solutions = Solution.where(contest: @contest, user_id: user_id).reorder(created_at: 'ASC')
    solutions = solutions.reject { |s| s.status == 'judge_error' }.group_by(&:problem_id)

    # separate the solutions by problem id
    filtered = Hash[if frozen?(user_id)
                      solutions.map &method(:frozen_filter)
                    else
                      solutions.map &method(:filter_solutions)
                    end]

    filtered_result(filtered)
  end

  # Does user is frozen to the opeartor
  def frozen?(user_id)
    # we don't freeze the status to the operator, staff
    # user_id will always in the contest
    return false if @opts[:skip_frozen]
    return false if user_id == @operator.id || @operator.staff?
    return false if end_at.past?
    frozen_at ? frozen_at.past? : false
  end

  # Much like filter_solutions, but take care of the frozen state
  def frozen_filter(data)
    problem_id, solutions = data
    _, result = filter_solutions(data)
    result = [false, solutions.count] if result[0] && result[2] > @contest.frozen_from_stareted_at_in_minute
    [problem_id, result]
  end

  # Filter and parse the accepted solution. If no solutions were selected,
  # leave it as is.
  # Require:
  #   - solutions exist
  #   - ordered by created time ASC
  #   - solution status is not judge_error
  # Doesn't care about the frozen status.
  # Two circumstances:
  #   - accepted solution exists
  #   - no accepted solution
  def filter_solutions(data)
    problem_id, solutions = data
    failed_attempts = solutions.take_while { |s| s.status != 'accepted_answer' }
    fails = failed_attempts.count
    is_accepted = (fails < solutions.count)
    if is_accepted
      solution = solutions[fails]
      accepted_time = solution.created_at
      delta = @contest.duration_with_started_at_in_minute(accepted_time)
      time_usage = delta + PENALTY_TIME * fails
      [problem_id, [is_accepted, fails + 1, delta, time_usage]]
    else
      [problem_id, [is_accepted, fails]]
    end
  end

  def filtered_result(filtered)
    accepted = filtered.inject(0) { |acc,m| acc + (m[1][0] ? 1 : 0) }
    tried = filtered.size
    time = filtered.inject(0) { |acc,m| acc + (m[1][0] ? m[1][3] : 0) }
    last_accepted = 0
    problems = filtered.map do |problem_id,result|
      result.pop if result[0]
      result.shift
      last_accepted = [last_accepted, result[1]].max if result.length == 2
      [problem_id, result]
    end

    [accepted, tried, time, last_accepted, Hash[problems]]
  end

  private

  def problem_ids
    @problem_ids ||= @contest.problem_ids
  end

  def started_at
    @started_at ||= @contest.started_at
  end

  def frozen_at
    @frozen_at ||= @contest.frozen_ranking_from
  end

  def end_at
    @end_at = @contest.end_at
  end
end
