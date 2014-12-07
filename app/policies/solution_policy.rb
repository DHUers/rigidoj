class SolutionPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
  end

  def permitted_attributes
    [:platform, :source]
  end
end
