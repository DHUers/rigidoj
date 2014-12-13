class StaticsController < ApplicationController
  def home
    return landing unless logged_in?
    @posts = Post.published.limit(10)
    render 'home', layout: 'application'
  end

  def landing
    render 'landing', layout: 'landing'
  end

  def about
    @post = Post.find_by(author_id: Rigidoj.system_user.id, title: 'About')

    render 'posts/show'
  end

  def help
    @post = Post.find_by(author_id: Rigidoj.system_user.id, title: 'Help')

    render 'posts/show'
  end
end
