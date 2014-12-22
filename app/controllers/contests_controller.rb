class ContestsController < ApplicationController
  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(contest_params)

    if @contest.save
      redirect_to @contest
    end
  end

  def index
    @contests = Contest.all
  end

  private

  def contest_params
    params.require(:contest).permit(*policy(@contest || Contest).permitted_attributes)
  end
end
