module SolutionsHelper
  def show_details?(solution)
    !%w(draft judging network_error judge_error
        compile_error output_limit_exceeded).include? solution.status
  end

  def status_span(solution)
    status = solution.status
    internal_id = Solution.statuses[status]
    pretty_text = SiteSetting.solution_statuses[internal_id]
    color = SiteSetting.solution_colors[internal_id]
    raw "<span class='solution-status-text #{status}' style='color: #{color}'>#{pretty_text}</span>"
  end
end
