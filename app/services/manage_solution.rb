class ManageSolution
  def self.publish_to_judgers(solution)
    ensure_queue_established

    solution_json = BasicSolutionSerializer.new(solution, root: 'solution').to_json
    case solution.problem.judge_type.to_sym
    when :remote_proxy
      $rabbitmq_judger_proxy_queue.publish solution_json
      Rails.logger.info "[Rabbitmq] Sent Solution #{solution.id} to remote proxy queue"
    else
      $rabbitmq_judger_queue.publish solution_json
      Rails.logger.info "[Rabbitmq] Sent Solution #{solution.id} to judge queue"
    end
  end

  def self.resolve_solution_result(payload)
    Rails.logger.info "[Rabbitmq] [Solution result consumer] #{$rabbitmq_result_queue.name} received a message: #{payload}"
    Rails.logger.info "[Solution result payload] #{payload}"
    solution = Solution.find payload[:id].to_i
    solution_params = {
        status: payload[:status],
        revision: payload[:revision],
        time_usage: payload[:time_usage],
        memory_usage: payload[:memory_usage]
    }
    solution_params[:report] = payload[:report] if payload[:report]
    solution_params[:detailed_report] = payload[:detailed_report] if payload[:detailed_report]
    solution.update_attributes solution_params

    announce_judged_result(solution)
  end

  def self.announce_judged_result(solution)
    text = solution.problem ? "Solution for #{solution.problem.title}" : "Solution"
    params = {
        notification_type: :solution_report,
        user_id: solution.user.id,
        data: "#{text}: #{solution.pretty_solution_status}",
        solution_id: solution.id
    }
    params[:problem_id] = solution.problem.id if solution.problem
    params[:contest_id] = solution.contest.id if solution.contest

    Notification.create!(params)

    MessageBus.publish '/notifications', 1, user_ids: [solution.user_id]
  end

  def self.ensure_queue_established
    unless $rabbitmq_judger_proxy_queue && $rabbitmq_judger_queue
      Rigidoj.start_rabbitmq
    end
  end
end
