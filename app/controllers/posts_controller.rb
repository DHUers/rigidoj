class PostsController < ApplicationController
  def index
    @posts = Post.published.paginate(page: params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    authorize @post

    @post.author = current_user.id
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
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
    params.require(:post).permit(*policy(@post || Post).permitted_attributes)
  end
end
