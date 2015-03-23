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

  def notification_item(notification)
    h = { unread: !notification.read, id: notification.id, content: notification.data }
    case notification.notification_type
    when 'solution_report'
      h[:icon_class] = 'code'
      h[:link] = "/solutions?username=#{current_user.username}"
    when 'contest_started'
      h[:icon_class] = 'clock-o'
      h[:link] = contest_path(notification.contest.slug, notification.contest.id)
    when 'contest_delayed'
      h[:icon_class] = 'exclamation-triangle'
      h[:link] = contest_path(notification.contest.slug, notification.contest.id)
    when 'contest_notification'
      h[:icon_class] = 'envelope-o'
      h[:link] = contest_path(notification.contest.slug, notification.contest.id)
    end
    h
  end
end
