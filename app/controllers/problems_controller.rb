class ProblemsController < ApplicationController
  def index
    @problems = Problem.published.order(:id).page(params[:page]).per(20)
  end

  def new
    @problem = Problem.find_by(draft: true, user: current_user)
    unless @problem
      @problem = Problem.create(user: current_user)
    end
  end

  def create
    @problem = Problem.new(problem_params)
    authorize @problem

    if @problem.save
      redirect_to @problem
    else
      render 'new'
    end
  end

  def show
    @problem = Problem.find(params[:id])
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])
    authorize @problem

    if @problem.update_attributes(problem_params)
      redirect_to @problem
    else
      render 'edit'
    end
  end

  def destory
    @problem = Problem.find(params[:id])
    authorize @problem

    if @problem.destroy
      render 'index'
    end
  end

  private

  def problem_params
    params.require(:problem).permit(*policy(@problem || Problem).permitted_attributes)
  end
end
