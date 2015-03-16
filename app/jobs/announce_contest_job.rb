class AnnounceContestJob < ActiveJob::Base
  queue_as :default

  def perform
    Contest.live.where(started_notified: false).each { |c| notified_contest_users(c, :started) }
    Contest.live.where(delayed_notified: false).each { |c| notified_contest_users(c, :delayed) }
  end

  def notified_contest_users(contest, type = 'started')
    type = "contest_#{type.to_s}"
    contest.users.each do |u|
      text = "Contest #{contest.title}"
      params = {
          user_id: u.id,
          notification_type: type.to_sym,
          contest_id: contest.id,
          data: "#{text}: #{type == 'contest_started' ? 'started' : 'delayed' }"
      }
      Notification.create!(params)
      MessageBus.publish '/notifications', 1
    end
  end

end
