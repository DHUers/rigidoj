class UsersController < ApplicationController
  def new
    @user = User.new
    render 'new', layout: 'lite'
  end

  def create

  end
end
