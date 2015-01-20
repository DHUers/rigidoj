class ProblemsController < ApplicationController
  def index
    @problems = policy_scope(Problem.published).order(:id).page(params[:page]).per(20)
  end

  def new
    @problem = Problem.new
    authorize @problem
  end

  def import
    @problem = ProblemDownloader.download_and_create_problem(params[:vendor].to_s, params[:id])
    authorize @problem
    render 'new'
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
    load_resource
  end

  def excerpt
    load_resource
  end

  def edit
    load_resource
  end

  def update
    load_resource

    if @problem.update_attributes(problem_params)
      render @problem
    else
      render 'edit'
    end
  end

  def destory
    load_resource

    if @problem.destroy
      render 'index'
    end
  end

  private

  def problem_params
    params.require(:problem).permit(*policy(@problem || Problem).permitted_attributes)
  end

  def load_resource
    @problem = Problem.find(params[:id])
    authorize @problem
  end
end
