require_dependency 'pretty_text'
require 'date'

class Contest < ActiveRecord::Base
  belongs_to :user
  has_many :contest_problems
  has_many :problems, -> { order('position ASC') }, through: :contest_problems

  accepts_nested_attributes_for :problems

  enum contest_type: [:normal, :delayable]
  enum contest_status: [:incoming, :delayed, :finished]

  scope :incoming, -> { where(contest_status: Contest.contest_statuses['incoming']) }
  scope :delayed, -> { where(contest_status: Contest.contest_statuses['delayed']) }
  scope :finished, -> { where(contest_status: Contest.contest_statuses['finished']) }

  validates_presence_of :title
  validates_presence_of :description_raw
  validates_presence_of :contest_status
  validates_presence_of :started_at
  validates_presence_of :end_at
  validates_with ::ContestTypeValidator

  before_create :create_slug
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

  def end_time
    delayed_till || end_at
  end

  def create_slug
    self.slug = Slug.for(title, 'contest')
  end

  def started?
    Time.now > started_at
  end

  def ended?
    Time.now > end_time
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
end

# == Schema Information
#
# Table name: contests
#
#  id                   :integer          not null, primary key
#  title                :string           not null
#  description_raw      :text             default("")
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description_baked    :text             default("")
#  contest_status       :integer          default("0"), not null
#  started_at           :datetime         not null
#  end_at               :datetime         not null
#  delayed_till         :datetime
#  contest_type         :integer          default("0"), not null
#  slug                 :string
#  frozen_ranklist_from :datetime
#
