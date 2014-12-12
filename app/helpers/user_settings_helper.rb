module UserSettingsHelper
  def active_if(action)
    action?(action, "update_#{action}") ? 'active': ''
  end

end
