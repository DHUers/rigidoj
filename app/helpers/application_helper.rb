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
end
