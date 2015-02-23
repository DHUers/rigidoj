class DelayableContest < Contest
end

# == Schema Information
#
# Table name: contests
#
#  id                  :integer          not null, primary key
#  title               :string           not null
#  description_raw     :text             default("")
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  description_baked   :text             default("")
#  status              :integer          default("0"), not null
#  started_at          :datetime         not null
#  end_at              :datetime         not null
#  delayed_till        :datetime
#  slug                :string
#  frozen_ranking_from :datetime
#  type                :string
#
