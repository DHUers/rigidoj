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
    @problem = @solution.problem

    if @solution.save
      publish_to_judgers
      render 'show'
    else
      render 'new'
    end
  end

  def index
    @solutions = policy_scope(Solution).order(:id).page(params[:page]).per(20)
  end

  def show
    @solution = Solution.find(params[:id])
    authorize @solution
  end

  private

  def publish_to_judgers
    Rigidoj.judger_queue.publish @solution.to_judger.to_msgpack
  end

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
