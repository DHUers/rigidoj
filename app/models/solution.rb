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

  after_create :publish_to_judgers, unless: 'Rails.env.test?'

  def ace_mode
    case self.platform
      when 'c', 'c++' then 'c_cpp'
      else self.platform
    end
  end

  def accpted?
    status == 'accepted_answer'
  end

  def publish_notification
    text = "Solution result: #{self.status}"
    notification_params = {
        notification_type: 'solution',
        user: self.user,
        data: text,
        solution: self
    }
    notification_params[:problem] = self.problem if self.problem
    notification_params[:contest] = self.contest if self.contest
    puts notification_params
    Notification.create!(notification_params)

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
end

# == Schema Information
#
# Table name: solutions
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  problem_id   :integer
#  contest_id   :integer
#  memory_usage :integer          default("0")
#  time_usage   :integer          default("0")
#  platform     :string           default(""), not null
#  revision     :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  source       :text             default("")
#  type         :string
#  report       :text             default("")
#  status       :integer          default("0"), not null
#
