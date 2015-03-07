require 'rigidoj'

class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  belongs_to :contest
  has_many :user_problem_stats
  enum status: [:judging, :network_error, :judge_error,
                :accepted_answer, :wrong_answer, :time_limit_exceeded,
                :memory_limit_exceeded, :presentation_error,
                :runtime_error, :compile_error, :output_limit_exceeded]

  default_scope {order('created_at DESC')}

  validates_presence_of :source, :problem_id, :user_id, :platform
  validate :contest_solution

  after_create :publish_to_judgers, unless: 'Rails.env.test?'
  after_create :update_first_created

  after_update :announce_judged_result

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
    stat.keep_track_latest_solution!(created_at)
    if new_record
      user.user_stat.solutions_created.increment!
    else
      update_accepted_stats(stat) if accepted?
    end
  end

  def update_accepted_stats(stat)
    unless stat.already_accepted?
      user.user_stat.problems_solved.increment!
      stat.mark_accepted_solution!(created_at)
    end
  end

  def accepted?
    status == 'accepted_answer'
  end

  def announce_judged_result

  end

  def contest_solution
    errors.add(:created_at, :invalid, options) if contest.ended?
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

  def announce_judged_result
    text = problem ? "Solution for #{problem.title}" : "Solution"
    params = {
        notification_type: :solution_report,
        user_id: user.id,
        data: "#{text}: #{pretty_solution_status}",
        solution_id: id
    }
    params[:problem_id] = problem.id if problem
    params[:contest_id] = contest.id if contest

    Notification.create!(params)

    MessageBus.publish '/notifications', 1
  end

  def publish_to_judgers
    solution_json = BasicSolutionSerializer.new(self, root: 'solution').to_json
    case problem.judge_type.to_sym
    when :remote_proxy
      $rabbitmq_judger_proxy_queue.publish solution_json
      Rails.logger.info "[Rabbitmq] Sent Solution #{id} to remote proxy queue"
    else
      $rabbitmq_judger_queue.publish solution_json
      Rails.logger.info "[Rabbitmq] Sent Solution #{id} to judge queue"
    end
  end

  def pretty_solution_status
    SiteSetting.solution_statuses[Solution.statuses[status]]
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
#  status          :integer          default("0"), not null
#  detailed_report :text
#
