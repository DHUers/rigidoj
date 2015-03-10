module ProblemsHelper

  def accepted_rate(problem)
    return '-' if problem.submission_count == 0

    "#{problem.accepted_count / problem.submission_count * 100}%"
  end

  def unique_anchor_id(problem)
    "#{problem.slug}-#{problem.id}"
  end
end
