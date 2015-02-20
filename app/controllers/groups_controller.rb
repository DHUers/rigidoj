class GroupsController < ApplicationController
  def person
    @user = User.find_by(username_lower: params[:username])
    render 'users/show'
  end
end