class UsersController < ApplicationController
  def new
    @user = User.new
    render 'new', layout: 'lite'
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      remember @user
      redirect_to root_path
    else
      render 'new', layout: 'lite'
    end
  end

  def user_params
    params.require(:user).permit(*policy(@user || User).permitted_attributes)
  end
end
