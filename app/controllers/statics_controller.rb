class StaticsController < ApplicationController
  def home
    authorize :static

    return landing unless logged_in?
    @posts = Post.pinned.limit(10)
    render 'home', layout: 'application'
  end

  def landing
    authorize :static

    render 'landing', layout: 'landing'
  end

  def about
    authorize :static

    @post = Post.find(3)
    @comment = Comment.new
    render 'posts/show'
  end

  def help
    authorize :static

    @post = Post.find(2)
    @comment = Comment.new
    render 'posts/show'
  end
end
