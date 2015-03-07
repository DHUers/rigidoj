class SolutionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def permitted_attributes
    [:platform, :source, :problem_id]
  end
end
