class Solution < ActiveRecord::Base
  belongs_to :user, inverse_of: :solutions
  belongs_to :problem, inverse_of: :solutions
  enum solution_status: [:accept_answer, :wrong_answer, :time_limit_exceeded,
                         :memory_limit_exceeded, :presentation_error,
                         :runtime_error, :compile_error, :output_limit_exceeded,
                         :waiting, :queueing, :network_error, :judge_error,
                         :other_error]
end

# == Schema Information
#
# Table name: solutions
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  problem_id      :integer
#  contest_id      :integer
#  solution_status :integer          default("0")
#  memory_usage    :integer          default("0")
#  time_usage      :integer          default("0")
#  platform        :string           default("0"), not null
#  revision        :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  source          :text             default("")
#  type            :string
#  report          :text             default("")
#
