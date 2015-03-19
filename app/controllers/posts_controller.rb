class PostsController < ApplicationController
  def index
    @posts = policy_scope(Post.all)
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = CommentCreator.create(current_user, post_params).post
    authorize @post

    unless @post.errors.any?
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
  end

  def update
    @post = Post.find(params[:id])
    authorize @post

    if @post.save
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destory
    @post = Post.find(params[:id])
    authorize @post

    if @post.destroy
      render 'index'
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
    render :new
  end

  def create_with_contest
    @contest = Contest.find(params[:contest_id])
    authorize @contest, :create_solution?
    @post = Post.new(post_params)
    @post.contest_id = @contest.id

    if @post.save
      redirect_to contest_post_path(@contest.slug, @contest.id, @post.id)
    else
      render :new
    end
  end

  def show_with_contest
    @post = Post.find(params[:post_id])

    render :show
  end

  private

  def post_params
    params.require(:comment).permit(*policy(@post || Post).permitted_attributes)
  end
end
