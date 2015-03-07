class StaticsController < ApplicationController
  def home
    authorize :static

    return landing unless logged_in?
    @posts = Post.published.limit(10)
    render 'home', layout: 'application'
  end

  def landing
    authorize :static

    render 'landing', layout: 'landing'
  end

  def about
    authorize :static

    @post = Post.find_by(user: Rigidoj.system_user, title: 'About')

    render 'posts/show'
  end

  def help
    authorize :static

    @post = Post.find_by(user: Rigidoj.system_user, title: 'Help')

    render 'posts/show'
  end
end
