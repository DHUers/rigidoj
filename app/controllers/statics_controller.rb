class StaticsController < ApplicationController
  def home
    unless logged_in?
      render 'landing', layout: 'landing'
      return
    end
    @posts = Post.published.limit(10)
    render 'home', layout: 'application'
  end
end
