module ApplicationHelper
  def controller?(*controller)
    controller.flatten.include?(params[:controller])
  end

  def action?(*action)
    action.flatten.include?(params[:action])
  end
end
