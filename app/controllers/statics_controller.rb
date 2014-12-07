class StaticsController < ApplicationController
  def home
    unless logged_in?
      render 'landing', layout: 'landing'
      return
    end
    @posts = Post.published.limit(10)
    render 'home', layout: 'application'
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
