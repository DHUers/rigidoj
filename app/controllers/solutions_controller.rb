class SolutionsController < ApplicationController
  def new
    @solution = Solution.new
  end
end
