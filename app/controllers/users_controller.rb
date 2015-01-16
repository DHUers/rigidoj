class UsersController < ApplicationController
  def new
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Successfully created your account. You can log in now."
      redirect_to login_path
    else
      flash[:danger] = "There were problems creating your account."
      render 'new'
    end
  end

  def show
    @user = User.find_by(username_lower: params[:username])
  end

  def edit
    @user = User.find_by(username_lower: params[:username])
  end

  def update

  end

  private

  def user_params
    params.require(:user).permit(*policy(@user || User).permitted_attributes)
  end
end
