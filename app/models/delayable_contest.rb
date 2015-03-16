class DelayableContest < Contest
  scope :delayed, -> { where('end_at <= ? AND delayed_till > ?', Time.zone.now, Time.zone.now) }

  def delayed?
    end_at.past?
  end

  def end_time
    delayed_till
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
#  judger_group        :integer
#  started_notified    :boolean          default(FALSE), not null
#  delayed_notified    :boolean          default(FALSE), not null
#
