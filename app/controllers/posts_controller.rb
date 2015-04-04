class PostsController < ApplicationController
  def index
    @posts = policy_scope(Post.all).page(params[:page]).per(20)
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    authorize :post
    creator = CommentCreator.new(current_user, post_params.merge(title: params[:post][:title]))
    @comment = creator.create
    @post = @comment.post
    unless creator.errors.any? || @comment.errors.any?
      redirect_to post_path(@post)
    else
      flash[:danger] = 'Error creating the post.'
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    authorize @post
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
    authorize @post
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    @comment = @post.first_comment
    @comment.raw = params[:comment][:raw]

    if @post.save && @comment.save
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize @post

    if @post.destroy
      redirect_to posts_path
    end
  end

  def toggle_pinned
    @post = Post.find(params[:post_id])
    authorize @post, :destroy?

    if @post.update_attribute(:pinned, !@post.pinned)
      render json: success_json
    else
      render json: failed_json, status: 400
    end
  end

  def toggle_visible
    @post = Post.find(params[:post_id])
    authorize @post, :destroy?

    if @post.update_attribute(:visible, !@post.visible)
      render json: success_json
    else
      render json: failed_json, status: 400
    end
  end

  def index_with_contest
    @contest = Contest.find(params[:contest_id])
    authorize @contest, :rejudge_solution?
    @posts = @contest.posts
  end

  def new_with_contest
    @contest = Contest.find(params[:contest_id])
    authorize @contest, :create_solution?
    @post = Post.new
    @posts = @contest.posts.where(user_id: current_user.id)
    render :new
  end

  def create_with_contest
    @contest = Contest.find(params[:contest_id])
    authorize @contest, :create_solution?
    creator = CommentCreator.new(current_user, post_params.merge(title: params[:post][:title], contest_id: @contest.id))
    @comment = creator.create
    @post = @comment.post
    unless creator.errors.any?
      redirect_to contest_post_path(@contest.slug, @contest.id, @post.id)
    else
      flash[:danger] = 'Error creating the post.'
      render :new
    end
  end

  def show_with_contest
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    authorize @post

    render :show
  end

  def index_with_problem
    @problem = Problem.find(params[:problem_id])
    authorize @problem, :show?
    @posts = @problem.posts
  end

  def new_with_problem
    @problem = Problem.find(params[:problem_id])
    authorize @problem, :show?
    @post = Post.new
    render :new
  end

  def create_with_problem
    @problem = Problem.find(params[:problem_id])
    authorize @problem, :show?
    creator = CommentCreator.new(current_user, post_params.merge(title: params[:post][:title], problem_id: @problem.id))
    @comment = creator.create
    @post = @comment.post
    unless creator.errors.any?
      redirect_to problem_post_path(@problem.slug, @problem.id, @post.id)
    else
      flash[:danger] = 'Error creating the post.'
      render :new
    end
  end

  def show_with_problem
    @problem = Problem.find(params[:problem_id])
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    authorize @problem, :show?

    render :show
  end

  private

  def post_params
    params.require(:comment).permit(*policy(@post || Post).permitted_attributes)
  end
end
