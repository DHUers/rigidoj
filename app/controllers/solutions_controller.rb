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
      publish_to_judgers
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

  def publish_to_judgers
    solution_json = BasicSolutionSerializer.new(@solution, root: 'solution').to_json
    case @solution.problem.judge_type.to_sym
    when :remote_proxy
      $rabbitmq_judger_proxy_queue.publish solution_json
      Rails.logger.info "[Rabbitmq] Sent Solution #{@solution.id} to remote proxy queue"
    else
      $rabbitmq_judger_queue.publish solution_json
      Rails.logger.info "[Rabbitmq] Sent Solution #{@solution.id} to judge queue"
    end
  end

  def solution_params
    params.require(:solution).permit(*policy(@solution || Solution).permitted_attributes)
  end
end
