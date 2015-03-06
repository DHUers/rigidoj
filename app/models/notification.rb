class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  belongs_to :solution
  belongs_to :contest

  enum notification_type: %i(solution_report)

  validates_presence_of :data
  validates_presence_of :notification_type

  scope :unread, lambda { where(read: false) }
  scope :recent, lambda { |n=10| order('created_at DESC').limit(n) }

  def self.recent_report(user, count = 10)
    user.notifications
        .recent(count)
        .to_a
  end

  def item_hash
    h = { unread: !read, id: id, content: data }
    h[:icon_class] = case notification_type
                     when 'solution_report' then 'code'
                     end
    h
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
#  read              :boolean          default("false"), not null
#  problem_id        :integer
#  solution_id       :integer
#  contest_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
