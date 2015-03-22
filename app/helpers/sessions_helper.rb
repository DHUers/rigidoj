module SessionsHelper
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_in(user)
    cookies[:message_bus_user_id] = user.id
    session[:user_id] = user.id
    make_developer_admin(user)
  end

  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def make_developer_admin(user)
    if user.active? && !user.admin &&
        Rails.configuration.x.respond_to?(:developer_emails) &&
        Rails.configuration.x.developer_emails.include?(user.email)
      user.admin = true
      user.save
    end
  end
end
