class UserSettingsController < ApplicationController
  def profile
    render 'users/settings/profile'
  end

  def update_profile
    @user = current_user

    if @user.update_attributes(profile_params)
      flash[:info] = 'Successfully update.'
    else
      flash[:danger] = 'Something wrong.'
    end
    render 'users/settings/profile'
  end

  def account
    render 'users/settings/account'
  end

  def update_account
    @user = current_user

    if @user.authenticate!(params[:old_password]) &&
        params[:new_password] == params[:confirmation_password]
      @user.password = params[:new_password]
      if @user.save
        flash[:info] = 'Successfully update.'
      else
        flash[:danger] = 'Something wrong.'
      end
    else
      flash[:danger] = 'Old password is incorrect.'
    end
    render 'users/settings/account'
  end

  def notification
    render 'users/settings/notification'
  end

  def update_notification
    @user = current_user

    if @user.update_attributes(notification_params)
      flash[:info] = 'Successfully update.'
    else
      flash[:danger] = 'Something wrong.'
    end
    render 'users/settings/profile'
  end

  private

  def profile_params
    params.require(:user).permit(:name, :username, :website, :avatar)
  end

  def account_params
    params.require(:user).permit(:old_password, :new_password, :confirmation_password)
  end

  def notification_params
    params.require(:user).permit(:email, :website)
  end
end
