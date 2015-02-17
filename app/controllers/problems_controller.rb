class ProblemsController < ApplicationController
  def index
    @problems = policy_scope(Problem.published).order(:id).page(params[:page]).per(20)

    render :index
  end

  def new
    vendor = params[:vendor]
    id = params[:id]
    puts vendor, id
    @problem = vendor && id ? ProblemDownloader.download_and_create_problem(vendor, id) : nil
    @problem ||= Problem.new
    authorize @problem

    render :new
  end

  def import
    if params[:vendor].to_s && params[:id].to_s
      render nothing: true, location: new_problem_path(vendor: params[:vendor], id: params[:id]), status: 303
    else
      render nothing: true, status: 404
    end
  end

  def create
    @problem = Problem.new(problem_params)
    authorize @problem

    if @problem.save
      redirect_to show_problem_path(@problem.slug, @problem.id)
    else
      flash[:danger] = 'Something wrong when creating problem.'
      render :new
    end
  end

  def show
    load_resource

    render :show
  end

  def excerpt
    load_resource
    render partial: 'problems/problem_item', locals: {removable: params[:removeable] == true || true}
  end

  def edit
    load_resource
  end

  def update
    load_resource

    if @problem.update_attributes(problem_params)
      render 'show'
    else
      flash[:danger] = 'Something wrong when updating problem.'
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
