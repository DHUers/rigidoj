class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  belongs_to :solution
  belongs_to :contest

  validates_presence_of :data
  validates_presence_of :notification_type

  scope :unread, lambda { where(read: false) }
  scope :recent, lambda {|n=nil| n ||= 10; order('created_at DESC').limit(n) }
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
