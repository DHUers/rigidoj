class ContestProblem < ActiveRecord::Base
  default_scope { order('position ASC')}
  belongs_to :problem
  belongs_to :contest

  validates_associated :problem, :contest

  def problem_title
    problem.title
  end
end

# == Schema Information
#
# Table name: contest_problems
#
#  contest_id :integer
#  problem_id :integer
#  position   :integer          default("0"), not null
#  id         :integer          not null, primary key
#
# Indexes
#
#  index_contest_problems_on_contest_id_and_problem_id  (contest_id,problem_id) UNIQUE
#
