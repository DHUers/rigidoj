module ProblemsHelper

  def accepted_rate(problem)
    return '-' unless problem.submission_count > 0

    "#{(problem.accepted_count.to_f / problem.submission_count * 100).round(2)}%"
  end

  def unique_anchor_id(problem)
    "#{problem.slug}-#{problem.id}"
  end
end
