class StaticsController < ApplicationController
  def index
    @posts = Post.published.limit(10)
  end
end
