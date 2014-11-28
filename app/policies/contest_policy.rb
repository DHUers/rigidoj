class ContestPolicy < ApplicationPolicy
  def create?
    true
  end

  def permitted_attributes
    [:title, :description]
  end
end
