class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username_or_email(params[:session][:login])
    if user && user.authenticate!(params[:session][:password])
      log_in user
      remember user
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
