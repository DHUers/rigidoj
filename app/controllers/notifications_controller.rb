class NotificationsController < ApplicationController
  def recent
    user = current_user
    notifications = Notification.where(user: user).limit(10)
    notifications.each {|n| n.update_attribute(:read, true) }
    render json: notifications
  end
end
