class SessionsController < ApplicationController
  def new
    authorize :session, :login?
  end
  
  def create
    user = User.find_by_username_or_email(params[:session][:login])
    authorize :session, :login?
    if user && user.authenticate!(params[:session][:password])
      log_on_user user
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    authorize :session, :logout?
    log_off_user
    redirect_to root_url
  end
end
