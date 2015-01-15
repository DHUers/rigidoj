class JudgeTypeValidator < ActiveModel::Validator
  def validate(record)
    return if record.send(:draft)

    presence_of(record, :judge_type)
    case problem.send(:judge_type).to_sym
    when :full_text
      presence_of(problem, :input_file, :output_file)
    when :program_comparison
      presence_of(problem, :judger_program, :judger_program_platform, :input_file, :output_file)
      judger_program_platform_validator(record)
    when :remote_proxy
      presence_of(problem, :remote_proxy, :remote_proxy_vendor)
    else
      record.errors.add(:judge_type, :invalid, options)
    end
  end

  def presence_of(problem, *attrs)
    attrs.each do |attr|
      problem.errors.add(attr, :blank, options) if problem.send(attr).blank?
    end
  end

  def judger_program_platform_validator(problem)
    unless SiteSetting.judger_platforms.split('|').include? problem.send(:judger_program_platform)
      record.errors.add(:judger_program_platform, :invalid, options)
    end
  end
end
