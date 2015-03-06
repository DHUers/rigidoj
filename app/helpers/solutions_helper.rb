module SolutionsHelper
  def show_details?(solution)
    !%w(draft judging network_error judge_error
        compile_error output_limit_exceeded).include? solution.status
  end

  def status_span(solution)
    status = solution.status
    pretty_text = solution.pretty_solution_status
    color = SiteSetting.solution_colors[Solution.statuses[status]]
    raw "<span class='solution-status-text #{status}' style='color: #{color}'>#{pretty_text}</span>"
  end
end
