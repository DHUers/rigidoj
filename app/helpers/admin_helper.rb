module AdminHelper
  def admin_action?(*action)
    controller?('admin/admin') && action?(action)
  end

  def active_class_if_admin_action(*action)
    raw admin_action?(action)? 'class="active"': ''
  end
end
