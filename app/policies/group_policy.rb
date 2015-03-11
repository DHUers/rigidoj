class GroupPolicy < ApplicationPolicy
  def create?
    admin?
  end

  def admin?
    user.admin?
  end

  def show?
    user
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
