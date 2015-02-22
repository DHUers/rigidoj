class SolutionsController < ApplicationController
  def new
    if params[:problem_id]
      @problem = Problem.find(params[:problem_id])
      @solution = Solution.new(problem: @problem, platform: 'java')
    else
      @solution = Solution.new
    end
  end

  def create
    @solution = Solution.new(solution_params.merge({user: current_user}))
    @solution.problem = Problem.find(params[:problem_id].to_i) unless @solution.problem

    if @solution.save
      redirect_to show_problem_path(@solution.problem.slug, @solution.problem.id)
    else
      render 'new'
    end
  end

  def index
    solution_scope = Solution
    if params[:problem_id]
      @problem = Problem.find(params[:problem_id])
      solution_scope = @problem.solutions
    end
    @solutions = policy_scope(solution_scope).order(:id).page(params[:page]).per(20)
  end

  def show
    @solution = Solution.find(params[:id])
    authorize @solution
  end

  private

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
