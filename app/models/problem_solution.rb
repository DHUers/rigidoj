class ProblemSolution < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user
  belongs_to :solution

  enum state: [:viewed, :tried, :accepted]

  validate :ensure_newer_solution
  before_save :update_states

  def ensure_newer_solution
    if last_submitted_at && solution &&
        last_submitted_at > solution.created_at
      errors.add(:last_submitted_at, :invalid, options)
    end
  end

  def update_states
    last_submitted_at = solution.created_at
    if solution
      if solution.status == 'accepted_answer'
        state = :accepted
      else
        state = :tries
      end
    end
  end
end

# == Schema Information
#
# Table name: problem_solutions
#
#  problem_id        :integer          not null
#  user_id           :integer          not null
#  solution_id       :integer
#  last_submitted_at :datetime
#  state             :integer          default("0")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
