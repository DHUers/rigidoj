class ContestsController < ApplicationController
  def new
    @contest = Contest.new

    render 'new'
  end

  def create
    @contest = Contest.new(contest_params)
    if @contest.save
      redirect_to show_contest_path(@contest.slug, @contest.id)
    else
      render 'new'
    end
  end

  def index
    @incoming_contests = Contest.incoming
    @delayed_contests = Contest.delayed
    @finished_contests = Contest.finished

    render 'index'
  end

  def show
    @contest = Contest.find(params[:id])
  end

  def ranking
    @contest = Contest.find(params[:id])
  end

  def edit
    @contest = Contest.find(params[:id])

    render 'edit'
  end

  def update
    @contest = Contest.find(params[:id])

    if @contest.update_attributes(contest_params)

      redirect_to show_contest_path(@contest.slug, @contest.id)
    else
      render 'edit'
    end
  end

  private

  def contest_params
    params.require(:contest).permit(:title, :description_raw, :started_at,
                                    :end_at, :delayed_till, :frozen_ranklist_from,
                                    :contest_type, :problem_ids => [])
  end
end
