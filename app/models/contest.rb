require_dependency 'pretty_text'
require 'active_support/time'

class Contest < ActiveRecord::Base
  has_many :contest_problems
  has_many :problems, -> { order('position ASC') }, through: :contest_problems
  has_many :contest_users
  has_many :users, -> { order('username ASC') } , through: :contest_users
  has_many :solutions

  accepts_nested_attributes_for :problems

  scope :incoming, -> { where('started_at > ?', Time.now ) }
  scope :live, -> { where('started_at <= ? AND end_at >= ?', Time.now, Time.now) }
  scope :finished, -> { where('end_at < ?', Time.now) }

  validates_presence_of :title
  validates_presence_of :description_raw
  validates_presence_of :started_at
  validates_presence_of :end_at
  validates_presence_of :problems
  validates_with ::ContestTypeValidator, on: :create

  before_create :create_slug
  before_save :cook

  def self.latest(limit = 3)
    Contest.all.order(:end_at, :delayed_till, :started_at).limit(limit)
  end

  def cook
    self.description_baked = PrettyText::cook(self.description_raw)
  end

  def end_time
    end_at
  end

  def create_slug
    self.slug = Slug.for(title, 'contest')
  end

  def started?
    started_at.past?
  end

  def ended?
    end_time.past?
  end

  %i(started_at end_at delayed_till).each do |setter|
    define_method("#{setter}=") do |val|
      begin
        write_attribute setter, Time.zone.parse(val)
        send setter
      rescue ArgumentError
        errors.add(setter, :invalid)
      end
    end
  end

  def duration_with_started_at_in_minute(time)
    ((time - started_at) / 60).ceil
  end

  def frozen_from_stareted_at_in_minute
    duration_with_started_at_in_minute(frozen_ranking_from || end_at)
  end

  def add_user(user)
    begin
      users.push user unless users.include?(user)
    rescue ActiveRecord::RecordNotUnique
    end
  end
end

# == Schema Information
#
# Table name: contests
#
#  id                  :integer          not null, primary key
#  title               :string           not null
#  description_raw     :text             default("")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  description_baked   :text             default("")
#  started_at          :datetime         not null
#  end_at              :datetime         not null
#  delayed_till        :datetime
#  slug                :string
#  frozen_ranking_from :datetime
#  type                :string
#
