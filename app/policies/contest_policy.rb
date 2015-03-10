class ContestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.staff?
  end

  def show?
    true
  end

  def update?
    user.staff?
  end

  def destroy?
    user.staff?
  end

  def ranking?
    show?
  end
end
