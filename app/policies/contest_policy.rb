class ContestPolicy < ApplicationPolicy
  def create?
    true
  end

  def permitted_attributes
    [:title, :description_raw, :started_at, :end_at, :delayed_till]
  end
end
