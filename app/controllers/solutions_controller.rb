class SolutionsController < ApplicationController
  def new
    if params[:problem_id]
      @problem = Problem.find(params[:problem_id])
      @solution = Solution.new(problem: @problem, platform: 'java')
    else
      @solution = Solution.new
    end
    authorize @solution
  end

  def create
    params = create_params
    @solution = Solution.new(params)
    authorize @solution

    if @solution.save
      if params[:contest_id] || params[:problem_id]
        contest = Contest.find(params[:contest_id])
        contest.add_user current_user if contest
        render json: success_json, status: 201
      else
        redirect_to show_problem_path(@solution.problem.slug, @solution.problem.id)
      end
    else
      if params[:contest_id] || params[:problem_id]
        render json: failed_json.merge({errors: @solution.errors.full_messages}), status: 400
      else
        render 'new'
      end
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
