class BasicProblemSerializer < ActiveModel::Serializer
  attributes :id, :judge_type, :judge_data

  def judge_data
    problem_judge_type = object.judge_type.to_sym
    data = if problem_judge_type == :remote_proxy
             {vendor: object.remote_proxy_vendor}
           else
             {input_file_url: object.input_file_url,
              output_file_url: object.output_file_url,
              judge_limits: object.judge_limits,
              per_case_limit: object.per_case_limit}
           end
    if (problem_judge_type == :program_comparison)
      data.merge!({judger_program_url: object.judger_program.read,
                   judger_program_platform: object.judger_program_platform})
    end
    data
  end
end
