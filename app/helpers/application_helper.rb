module ApplicationHelper
  def controller?(*controller)
    controller.flatten.include?(params[:controller])
  end

  def action?(*action)
    action.flatten.include?(params[:action])
  end

  def platform_select_options
    @platform_options ||= SiteSetting.judger_platforms.map {|p| p.capitalize }.zip(SiteSetting.judger_platforms)
  end

  def field_describer(errors, description = nil)
    return "<p class='error-explanation'>#{errors.first}</p>".html_safe if errors.any?
    return "<p class='note'>#{description}</p>".html_safe if description
  end

  def staff?
    current_user ? current_user.staff? : false
  end
end
