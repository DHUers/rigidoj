require_dependency 'pretty_text'

class Contest < ActiveRecord::Base
  belongs_to :user
  has_many :contest_problems
  has_many :problems, -> { order('position ASC') }, through: :contest_problems

  enum contest_status: [:incoming, :delayed, :finished]

  scope :incoming, -> { where(contest_status: 'incoming') }
  scope :delayed, -> { where(contest_status: 'delayed') }
  scope :finished, -> { where(contest_status: 'finished') }

  before_save :cook

  def self.latest(limit = 3)
    latest = incoming.limit(limit)
    latest << delayed.limit(limit - latest.count).flatten if latest.count <= limit
    latest << finished.limit(limit - latest.count).flatten if latest.count <= limit
    latest.flatten
  end

  def cook
    self.description_baked = PrettyText::cook(self.description_raw)
  end

  def progress
    progress = (Time.now - started_at).to_f / (end_at - started_at) * 100
    progress >= 100 ? 100 : progress
  end

  def end_time
    delayed_till
  end
end

# == Schema Information
#
# Table name: contests
#
#  id                :integer          not null, primary key
#  title             :string           not null
#  description_raw   :text             default("")
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  description_baked :text             default("")
#  contest_status    :integer          default("0"), not null
#  started_at        :datetime         not null
#  end_at            :datetime         not null
#  delayed_till      :datetime
#  contest_type      :integer          default("0"), not null
#
