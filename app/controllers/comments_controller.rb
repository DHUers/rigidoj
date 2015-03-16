class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    authorize @comment
  end

  def create
    @comment = Comment.new(comment_params)
    authorize @comment
    @comment.user_id = current_user.id
    if params[:post_id]
      @post = Post.find(params[:post_id])
      authorize @post, :show?
      @comment.post_id = @post.id
      @comment.comment_number = @post.comments.count + 1
    end

    if @comment.save
      redirect_to post_path(@post)
    else
      flash[:danger] = "Can't be blank."
      redirect_to post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:raw)
  end
end
