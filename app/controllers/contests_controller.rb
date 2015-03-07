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
      redirect_to show_contest_path(@contest.slug, @contest.id)
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
  end

  def ranking
    @contest = Contest.find(params[:id])
    authorize @contest
    @ranking = ContestRanking.rank(current_user, @contest)
    authorize @contest, :ranking?

    render 'ranking'
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
      redirect_to show_contest_path(@contest.slug, @contest.id)
    else
      flash[:danger] = 'There are problems when update contest.'
      render 'edit'
    end
  end

  private

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
