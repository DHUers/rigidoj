class StaticsController < ApplicationController
  def home
    unless signed_in?
      render 'landing', layout: 'landing'
      return
    end
    @posts = Post.published.limit(10)
  end
end
