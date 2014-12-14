class SolutionsController < ApplicationController
  def new
    @problem = Problem.find(params[:problem_id])
    @solution = Solution.new(problem: @problem, platform: 'java')
  end

  def create
    @solution = Solution.new(solution_params.merge({user: current_user}))
    @problem = @solution.problem

    if @solution.save
      publish_to_judgers
      render @solution
    else
      render 'new'
    end
  end

  private

  def publish_to_judgers
    Rigidoj.judger_queue.publish @solution.to_judger.to_msgpack
  end

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
