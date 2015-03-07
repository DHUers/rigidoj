class ContestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    staff?
  end

  def show?
    true
  end

  def update?
    staff?
  end

  def destroy?
    staff?
  end

  def ranking?
    show?
  end
end
