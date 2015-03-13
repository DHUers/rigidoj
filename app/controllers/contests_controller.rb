class ContestsController < ApplicationController
  def new
    @contest = Contest.new
    authorize @contest
  end

  def create
    @contest = Contest.new(contest_params)
    authorize @contest

    if @contest.save
      sort_problems_by_ids(contest_params[:problem_ids])
      redirect_to contest_path(@contest.slug, @contest.id)
    else
      flash[:danger] = 'There are problems when create contest.'
      render 'new'
    end
  end

  def index
    @incoming_contests = policy_scope Contest.incoming
    @live_contests = policy_scope Contest.live
    @delayed_contests = policy_scope DelayableContest.delayed
    @finished_contests = policy_scope Contest.finished
  end

  def show
    @contest = Contest.find(params[:id])
    authorize @contest

    @contest_policy = policy(@contest)
    if @contest_policy.show_details? && !current_user.admin?
      if @contest.public_contest?
        @contest.add_user(current_user) unless @contest.in_judger_group?(current_user)
      else
        @contest.add_user(current_user) if @contest.in_visible_to_group?(current_user)
      end
    end
  end

  def ranking
    @contest = Contest.find(params[:id])
    authorize @contest, :show_details?
    @ranking = ContestRanking.rank(current_user, @contest)
  end

  def edit
    @contest = Contest.find(params[:id])
    authorize @contest
  end

  def update
    @contest = Contest.find(params[:id])
    authorize @contest

    if @contest.update_attributes(contest_params(@contest.type))
      sort_problems_by_ids(contest_params(@contest.type)[:problem_ids])
      redirect_to contest_path(@contest.slug, @contest.id)
    else
      flash[:danger] = 'There are problems when update contest.'
      render 'edit'
    end
  end

  def create_solution
    @solution = Solution.new(solution_params)
    authorize @solution, :create?
    @contest = Contest.find(params[:contest_id])
    authorize @contest, :create_solution?

    @solution.user_id = current_user.id
    if params[:solution][:contest_problem_id]
      problem = @contest.problems.fetch(params[:solution][:contest_problem_id].to_i)
      @solution.problem_id = problem.id
    end
    @solution.contest_id = @contest.id

    if @solution.save
      ManageSolution.publish_to_judgers(@solution)
      render json: success_json, status: 201
    else
      render json: failed_json.merge({ errors: @solution.errors.full_messages }), status: 400
    end
  end

  def solutions
    @contest = Contest.find(params[:contest_id])
    authorize @contest, :show_details?

    @solutions = Solution.where(contest_id: @contest.id).order(:id).page(params[:page]).per(20)

    render 'solutions/index'
  end

  private

  def solution_params
    params.require(:solution).permit(*policy(Solution).permitted_attributes)
  end

  def contest_params(type = nil)
    type = type ? type.underscore.to_sym : :contest
    params.require(type).permit(:title, :description_raw, :started_at,
                                :end_at, :delayed_till, :frozen_ranking_from,
                                :type, :problem_ids => [])
  end

  def sort_problems_by_ids(problem_ids)
    problem_ids.map {|p| p.to_i}.select {|p| 1 <= p && p <= Problem.count}
        .each_with_index do |p,i|
      cp = ContestProblem.find_by(problem_id: p.to_i)
      cp.update_attribute(:position, i)
    end
  end
end
