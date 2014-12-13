class SolutionsController < ApplicationController
  def new
    @problem = Problem.find(params[:problem_id])
    @solution = Solution.new(problem: @problem)
  end

  def create
    @solution = Solution.new(solution_params)

    if @solution.save
      publish_to_judgers
      render @solution
    else
      render 'new'
    end
  end

  private

  def publish_to_judgers
    Rigidoj.judger_queue.publish
  end

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
