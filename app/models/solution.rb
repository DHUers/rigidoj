class Solution < ActiveRecord::Base
  belongs_to :user, inverse_of: :solutions
  belongs_to :problem, inverse_of: :solutions
end

# == Schema Information
#
# Table name: solutions
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  problem_id   :integer
#  contest_id   :integer
#  result       :integer          default("0")
#  memory_usage :integer          default("0")
#  time_usage   :integer          default("0")
#  language     :string           default("0")
#  revision     :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  source       :text             default("")
#
