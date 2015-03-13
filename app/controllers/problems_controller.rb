class ProblemsController < ApplicationController
  def index
    @problems = policy_scope(Problem.published).order(:id).page(params[:page]).per(20)
  end

  def new
    vendor = params[:vendor]
    id = params[:id]
    puts vendor, id
    @problem = begin
      vendor && id ? ProblemDownloader.download_and_create_problem(vendor, id) : nil
    rescue
      flash[:danger] = 'Problem downloader encounters a error, report this would be very helpful.'
      nil
    end
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
      redirect_to problem_path(@problem.slug, @problem.id)
    else
      flash[:danger] = 'Something wrong when creating problem.'
      render :new
    end
  end

  def show
    @problem = Problem.find(params[:id])
    authorize @problem
  end

  def excerpt
    @problem = Problem.find(params[:id])
    authorize @problem

    render partial: 'problems/problem_item', locals: {removable: params[:removeable] == true || true}
  end

  def edit
    @problem = Problem.find(params[:id])
    authorize @problem
  end

  def update
    @problem = Problem.find(params[:id])
    authorize @problem

    if @problem.update_attributes(problem_params)
      redirect_to problem_path(@problem.slug, @problem.id)
    else
      flash[:danger] = 'Something wrong when updating problem.'
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

  def create_solution
    @solution = Solution.new(solution_params)
    authorize @solution, :create?
    @problem = Problem.find(params[:problem_id])
    authorize @problem, :show?

    @solution.user_id = current_user.id
    @solution.problem_id = @problem.id

    if @solution.save
      ManageSolution.publish_to_judgers(@solution)
      render json: success_json, status: 201
    else
      render json: failed_json.merge({ errors: @solution.errors.full_messages }), status: 400
    end
  end

  private

  def solution_params
    params.require(:solution).permit(*policy(Solution).permitted_attributes)
  end

  def problem_params
    params.require(:problem).permit(*policy(@problem || Problem).permitted_attributes)
  end
end
