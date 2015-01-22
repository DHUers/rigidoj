class Solution < ActiveRecord::Base
  belongs_to :user, inverse_of: :solutions
  belongs_to :problem, inverse_of: :solutions
  # enum solution_status: [:draft, :waiting, :queueing, :network_error,
  #                        :judge_error, :other_error, :accept_answer,
  #                        :wrong_answer, :time_limit_exceeded,
  #                        :memory_limit_exceeded, :presentation_error,
  #                        :runtime_error, :compile_error, :output_limit_exceeded]

  default_scope { order('created_at DESC')}

  validates_presence_of :source
  validates_presence_of :problem_id
  validates_presence_of :user_id
  validates_presence_of :platform

  after_create :increment_problem_submission_count
  after_save :increment_problem_accepted_count

  def increment_problem_submission_count
    if (problem = self.problem)
      problem.submission_count += 1
      problem.save
    end
  end

  def increment_problem_accepted_count
    if (solution_status == 'accept' && problem = self.problem)
      problem.accepted_count += 1
      problem.save
    end
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
#  solution_status :string           default(""), not null
#  source_length   :integer          default("0")
#
