class NotificationsController < ApplicationController
  def recent
    authorize :static, :notifications?

    render partial: 'components/notification_badge'
  end

  def read
    authorize :static, :notifications?

    notification_ids = params[:notificationIds] || []
    notification_ids.each do |id|
      n = Notification.find(id)
      return unless n.user.id == current_user.id
      n.update_attribute(:read, true)
    end
    render nothing: 201
  end
end
