class UserSettingsController < ApplicationController
  def profile
    authorize :user_setting, :profile?
    render 'users/settings/profile'
  end

  def update_profile
    @user = current_user
    authorize :user_setting, :profile?

    if @user.update_attributes(profile_params)
      flash[:info] = 'Successfully update.'
    else
      flash[:danger] = 'Something wrong.'
    end
    render 'users/settings/profile'
  end

  def account
    authorize :user_setting, :account?

    render 'users/settings/account'
  end

  def update_account
    @user = current_user
    authorize :user_setting, :account?

    if @user.authenticate!(params[:user][:old_password]) &&
        params[:user][:new_password] == params[:user][:confirmation_password]
      @user.password = params[:user][:new_password]
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

  def update_email
    @user = current_user
    authorize :user_setting, :account?

    if @user.update_attributes(account_params)
      flash[:info] = 'Successfully update.'
    else
      flash[:danger] = 'Something wrong.'
    end
    redirect_to settings_account_path
  end

  def notification
    authorize :user_setting, :notification?

    render 'users/settings/notification'
  end

  def update_notification
    @user = current_user
    authorize :user_setting, :notification?

    if @user.update_attributes(notification_params)
      flash[:info] = 'Successfully update.'
    else
      flash[:danger] = 'Something wrong.'
    end
    render 'users/settings/profile'
  end

  private

  def profile_params
    params.require(:user).permit(:name, :username, :website, :avatar, :crew, :student_id)
  end

  def account_params
    params.require(:user).permit(:old_password, :new_password, :confirmation_password, :email)
  end

  def notification_params
    params.require(:user).permit(:email, :website)
  end
end
