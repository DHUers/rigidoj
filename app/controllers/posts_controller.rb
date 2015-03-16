class PostsController < ApplicationController
  def index
    @posts = policy_scope(Post.all)
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = CommentCreator.create(current_user, post_params)
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

  private

  def post_params
    params.require(:comment).permit(*policy(@post || Post).permitted_attributes)
  end
end
