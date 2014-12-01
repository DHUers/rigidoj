class SolutionsController < ApplicationController
  def new
    @solution = Solution.new
  end

  def create
    @solution = Solution.new(solution_param)

    Solution.find_by(user_id: params[:userd])
  end

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
