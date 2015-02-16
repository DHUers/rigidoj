class ContestsController < ApplicationController
  def new
    @contest = Contest.new

    render 'new'
  end

  def create
    @contest = Contest.new(contest_params)
    new_problems_list = MultiJson.load(params[:problems]).uniq.map {|s| s.to_i}
                            .delete_if {|p| p <= 0 || p > Problem.count}
    new_problems_list.each {|p| @contest.problems << Problem.find(p)}

    if @contest.save
      redirect_to 'show'
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

    render 'show'
  end

  def edit
    @contest = Contest.find(params[:id])

    render 'edit'
  end

  def update
    @contest = Contest.find(params[:id])

    if @contest.update_attributes(contest_params)
      new_problems_list = MultiJson.load(params[:problems]).uniq.map {|s| s.to_i}
                              .delete_if {|p| p <= 0 || p > Problem.count}
      (@contest.problem_ids - new_problems_list).each {|p| @contest.delete(Problem.find(p))}
      new_problems_list.each_with_index do |p, i|
        problem = Problem.find(p)
        if (item = @contest.contest_problems.find_by(problem: problem))
          item.update_attribute(:position, i)
        else
          @contest.contest_problems.build(contest: @contest, problem: problem, position: i)
        end
      end
      @contest.save

      render 'show'
    else
      render 'edit'
    end
  end

  private

  def contest_params
    params.require(:contest).permit(*policy(@contest || Contest).permitted_attributes)
  end
end
