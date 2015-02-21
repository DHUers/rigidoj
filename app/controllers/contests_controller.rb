class ContestsController < ApplicationController
  def new
    @contest = Contest.new

    render 'new'
  end

  def create
    @contest = Contest.new(contest_params)
    puts params[:problems]
    new_problems_list = MultiJson.load(params[:problems]).uniq.map {|s| s.to_i}
                            .delete_if {|p| p <= 0 || p > Problem.count}
    puts new_problems_list
    if @contest.save
      new_problems_list.each_with_index do |p,i|
        puts "id: #{p}"
        problem = Problem.find(p)
        puts problem
        @contest.contest_problems.build(contest: @contest, problem: problem, position: i)
      end
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
