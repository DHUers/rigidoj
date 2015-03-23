class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  belongs_to :solution
  belongs_to :contest

  enum notification_type: %i(solution_report contest_started contest_delayed contest_notification)

  validates_presence_of :data
  validates_presence_of :notification_type

  scope :unread, lambda { where(read: false) }
  scope :recent, lambda { |n=10| order('created_at DESC').limit(n) }

  def self.recent_report(user, count = 10)
    user.notifications
        .recent(count)
        .to_a
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  notification_type :integer          not null
#  user_id           :integer          not null
#  data              :string           not null
#  read              :boolean          default(FALSE), not null
#  problem_id        :integer
#  solution_id       :integer
#  contest_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
