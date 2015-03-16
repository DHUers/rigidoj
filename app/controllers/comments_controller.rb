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
      @comment.comment_number = @post.comment_count + 1
    end

    if @comment.save
      redirect_to post_path(@post)
    else
      flash[:danger] = "Can't be blank."
      redirect_to post_path(@post)
    end
  end

  def destroy
    @comment = Comment.find(params[:id] || params[:comment_id])
    authorize @comment

    if @comment.destroy
      redirect_to post_path(@comment.post)
    else
      render json: failed_json, status: 400
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:raw)
  end
end
