require 'rigidoj'

class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  belongs_to :contest
  enum status: [:judging, :network_error, :judge_error,
                :accepted_answer, :wrong_answer, :time_limit_exceeded,
                :memory_limit_exceeded, :presentation_error,
                :runtime_error, :compile_error, :output_limit_exceeded]

  default_scope {order('created_at DESC')}

  validates_presence_of :source, :problem_id, :user_id, :platform
  validate :contest_solution

  after_initialize :set_default_report

  after_create :update_first_created

  around_save :update_stats

  def update_first_created
    unless user.user_stat.submitted?
      user.user_stat.set_first_solution! created_at
    end
  end

  def update_stats
    new_record = new_record?

    yield

    stat = UserProblemStat
        .where(user_id: user_id, problem_id: problem_id)
        .first_or_create
    stat.keep_track_latest_solution_time!(created_at)
    if new_record
      user.user_stat.increment!(:solutions_created)
      problem.increment!(:submission_count) unless contest
    else
      update_accepted_stats(stat) if accepted?
    end
  end

  def update_accepted_stats(stat)
    unless stat.already_accepted?
      user.user_stat.increment!(:problems_solved)
      stat.mark_accepted_solution_time!(created_at)
      problem.increment!(:accepted_count) unless contest
    end
  end

  def accepted?
    status == 'accepted_answer'
  end

  def contest_solution
    errors.add(:created_at, :invalid, options) if (!contest.nil?) && contest.ended?
  end

  def ace_mode
    case self.platform
      when 'c', 'c++' then 'c_cpp'
      else self.platform
    end
  end

  def accpted?
    status == 'accepted_answer'
  end

  def pretty_solution_status
    SiteSetting.solution_statuses[Solution.statuses[status]]
  end

  def set_default_report
    self.report = "<p>Judging</p>"
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
#  memory_usage    :integer          default(0)
#  time_usage      :integer          default(0)
#  platform        :string           default(""), not null
#  revision        :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  source          :text             default("")
#  type            :string
#  report          :text             default("")
#  status          :integer          default(0), not null
#  detailed_report :text
#
