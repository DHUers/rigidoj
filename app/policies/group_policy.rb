class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user && user.staff?
        scope.all
      else
        scope.where(visible: true)
      end
    end
  end

  def create?
    admin?
  end

  def admin?
    user && user.admin?
  end

  def show?
    record.visible || user && user.staff?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
