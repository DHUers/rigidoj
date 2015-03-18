class SolutionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(contest_id: nil)
    end
  end

  def create?
    true
  end

  def report?
    true
  end

  def permitted_attributes
    [:platform, :source, :problem_id]
  end
end
