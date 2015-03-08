class JudgeTypeValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:judge_type, :blank, options) unless record.send(:judge_type).present?

    case record.send(:judge_type).to_sym
    when :full_text
      file_present(record, :input_file, :output_file)
    when :program_comparison
      file_present(record, :judger_program, :input_file, :output_file)
      validate_judger_program_platform(record)
    when :remote_proxy
      record.errors.add(:remote_proxy_vendor, :blank, options) unless record.send(:remote_proxy_vendor).present?
    else
      record.errors.add(:judge_type, :invalid, options)
    end
  end

  def file_present(problem, *attrs)
    attrs.each do |attr|
      unless problem.send(attr).present?
        attacher = "#{attr}_attacher"
        problem.errors.add(attr, :blank, options) unless problem.send(attacher).present?
      end
    end
  end

  def validate_judger_program_platform(problem)
    unless SiteSetting.judger_platforms.include? problem.send(:judger_program_platform)
      problem.errors.add(:judger_program_platform, :invalid, options)
    end
  end
end
