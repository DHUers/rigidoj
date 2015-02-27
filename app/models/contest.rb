require_dependency 'pretty_text'
require 'active_support/time'

class Contest < ActiveRecord::Base
  has_many :contest_problems
  has_many :problems, -> {order('position ASC')}, through: :contest_problems
  has_many :contest_users
  has_many :users, through: :contest_users

  accepts_nested_attributes_for :problems

  scope :incoming, -> { where('started_at > ?', Time.now ) }
  scope :live, -> { where('started_at <= ? AND end_at >= ?', Time.now, Time.now) }
  scope :finished, -> { where('end_at < ?', Time.now) }

  validates_presence_of :title
  validates_presence_of :description_raw
  validates_presence_of :started_at
  validates_presence_of :end_at
  validates_with ::ContestTypeValidator

  before_create :create_slug
  before_save :cook

  def self.latest(limit = 3)
    Contest.all.order(:end_at, :delayed_till, :started_at).limit(limit)
  end

  def cook
    self.description_baked = PrettyText::cook(self.description_raw)
  end

  def end_time
    delayed_till || end_at
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

  def started_at=(started_at)
    write_attribute :started_at, DateTime.parse(started_at)
    self.started_at
  rescue ArgumentError
    errors.add(:started_at, 'is invalid')
  end

  def end_at=(end_at)
    write_attribute :end_at, DateTime.parse(end_at)
    self.end_at
  rescue ArgumentError
    errors.add(:end_at, 'is invalid')
  end

  def delayed_till=(delayed_till)
    write_attribute :delayed_till, DateTime.parse(delayed_till)
    self.delayed_till
  rescue ArgumentError
    errors.add(:delayed_till, 'is invalid')
  end

  def duration_with_started_at_in_minute(time)
    (time - started_at).to_i / 60
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
