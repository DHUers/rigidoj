class ProblemsController < ApplicationController
  def index
    @problems = Problem.published.paginate(page: params[:page])
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(problem_params)
    authorize @problem

    @problem.author = current_user.id
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

    if @problem.save
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
