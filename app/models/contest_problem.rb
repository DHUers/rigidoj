class ContestProblem < ActiveRecord::Base
  default_scope { order('position ASC')}
  self.primary_key = [:contest_id, :problem_id]
  belongs_to :problem
  belongs_to :contest
end

# == Schema Information
#
# Table name: contest_problems
#
#  contest_id :integer          primary key
#  problem_id :integer          primary key
#  position   :integer          default("0"), not null
#
# Indexes
#
#  index_contest_problems_on_contest_id_and_problem_id  (contest_id,problem_id) UNIQUE
#
