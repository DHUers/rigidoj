class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  belongs_to :contest
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

  def publish_notification
    text = "Solution result: #{self.solution_status}"
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
