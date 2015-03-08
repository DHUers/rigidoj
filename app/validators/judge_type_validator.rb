class JudgeTypeValidator < ActiveModel::Validator
  def validate(record)
    presence_of(record, :judge_type)
    case record.send(:judge_type).to_sym
    when :full_text
      presence_of(record, :input_file_id, :output_file_id)
    when :program_comparison
      presence_of(record, :judger_program_id, :judger_program_platform, :input_file_id, :output_file_id)
      validate_judger_program_platform(record)
    when :remote_proxy
      presence_of(record, :remote_proxy_vendor)
    else
      record.errors.add(:judge_type, :invalid, options)
    end
  end

  def presence_of(problem, *attrs)
    attrs.each do |attr|
      problem.errors.add(attr, :blank, options) if problem.send(attr).blank?
    end
  end

  def validate_judger_program_platform(problem)
    unless SiteSetting.judger_platforms.include? problem.send(:judger_program_platform)
      problem.errors.add(:judger_program_platform, :invalid, options)
    end
  end
end
