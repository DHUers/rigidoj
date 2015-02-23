module SolutionsHelper
  def show_details?(solution)
    !%w(draft judging network_error judge_error
        compile_error output_limit_exceeded).include? solution.status
  end
end
