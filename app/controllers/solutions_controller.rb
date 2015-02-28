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
    additional_params = {user: current_user}
    if (problem_index = params[:solution][:contest_problem_id])
      contest = Contest.find(params[:contest_id])
      additional_params.merge!({contest: contest})
      problem = contest.problems.fetch(problem_index.to_i)
      additional_params.merge!({problem_id: problem.id}) if problem
    elsif params[:problem_id]
      additional_params[:problem_id] = params[:problem_id]
    end
    @solution = Solution.new(solution_params.merge(additional_params))

    if @solution.save
      if params[:contest_id] || params[:problem_id]
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

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
