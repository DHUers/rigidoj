class Solution < ActiveRecord::Base
  belongs_to :user, inverse_of: :solutions
  belongs_to :problem, inverse_of: :solutions
  # enum solution_status: [:draft, :waiting, :queueing, :network_error,
  #                        :judge_error, :other_error, :accept_answer,
  #                        :wrong_answer, :time_limit_exceeded,
  #                        :memory_limit_exceeded, :presentation_error,
  #                        :runtime_error, :compile_error, :output_limit_exceeded]

  validates_presence_of :source
  validates_presence_of :problem_id
  validates_presence_of :user_id
  validates_presence_of :platform

  after_save :increment_problem_submission_count

  def increment_problem_submission_count
    self.problem.submission_count += 1 if self.problem
  end

  def ace_mode
    case self.platform
      when 'c', 'c++' then 'c_cpp'
      else self.platform
    end
  end
end

# == Schema Information
#
# Table name: solutions
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  problem_id      :integer
#  contest_id      :integer
#  memory_usage    :integer          default("0")
#  time_usage      :integer          default("0")
#  platform        :string           default(""), not null
#  revision        :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  source          :text             default("")
#  type            :string
#  report          :text             default("")
#  solution_hash   :string
#  solution_status :string           default(""), not null
#  source_length   :integer          default("0")
#
# Indexes
#
#  index_solutions_on_solution_hash  (solution_hash)
#
