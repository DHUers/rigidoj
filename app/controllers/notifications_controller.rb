class NotificationsController < ApplicationController
  def recent
    user = current_user
    notifications = Notification.where(user: user).limit(10)
    render json: notifications
    notifications.each {|n| n.update_attribute(:read, true) }
  end
end
