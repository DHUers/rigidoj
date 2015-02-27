class GroupPolicy < ApplicationPolicy
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    user && user.staff?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
