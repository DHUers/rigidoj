class SolutionsController < ApplicationController
  def new
    @solution = Solution.new
    authorize @solution
  end

  def create
    @solution = Solution.new(solution_params)
    authorize @solution

    @solution.user_id = current_user.id if current_user

    if @solution.save
      ManageSolution.publish_to_judgers(@solution)
      redirect_to solutions_path
    else
      render 'new'
    end
  end

  def index
    solution_scope = Solution
    if params[:problem_id]
      @problem = Problem.find(params[:problem_id])
      solution_scope = @problem.solutions
    elsif params[:contest_id]
      @contest = Contest.find(params[:contest_id])
      solution_scope = Solution.where(contest_id: @contest.id)
    else
      solution_scope = Solution.where(contest_id: nil)
    end
    @solutions = policy_scope(solution_scope).order(:id).page(params[:page]).per(20)

    render 'index'
  end

  def show
    @solution = Solution.find(params[:id])
    authorize @solution
  end

  def report
    @solution = Solution.find(params[:solution_id])
    authorize @solution

    report = @solution.user_id == current_user ? @solution.report : ''
    report << "<pre><code>#{@solution.source}</code></pre>" if current_user && (current_user.id == @solution.user_id || current_user.admin?)
    report << @solution.detailed_report if current_user && current_user.admin?

    report = "<p>Not authorized.</p>" if report.blank?
    render json: { report: report }
  end

  private

  def create_params
    result = solution_params.merge({ user_id: current_user.id })
    if params[:contest_id]
      contest = Contest.find(params[:contest_id])
      result[:contest_id] = contest.id
      if params[:solution][:contest_problem_id]
        problem = contest.problems.fetch(params[:solution][:contest_problem_id].to_i)
        result[:problem_id] = problem.id
      end
    elsif params[:problem_id]
      result[:problem_id] = params[:problem_id]
    end

    result
  end

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
