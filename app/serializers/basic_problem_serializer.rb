class BasicProblemSerializer < ApplicationSerializer
  attributes :judge_type, :judge_data

  def limits
    limits = {default: {
        time: object.default_time_limit,
        memory: object.default_memory_limit}}
    object.additional_limits.each do |l|
      limits.store(l['platform'], {'time' => l['time'], 'memory' => l['memory']})
    end
  end

  def judge_data
    case object.judge_type.to_sym
    when :full_text
      {
        input_file_url: object.input_file_url,
        output_file_url: object.output_file_url
      }
    when :program_comparison
      {
        judger_program_url: object.judger_program_url,
        judger_program_platform: object.judger_program_platform,
        input_file_url: object.input_file_url,
        output_file_url: object.output_file_url
      }
    when :remote_proxy
      {
        vendor: object.remote_proxy_vendor
      }
    end
  end
end
