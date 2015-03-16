class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where(published: false)
      end

    end
  end

  def create?
    user.admin?
  end

  def show?
    record.published? || user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    [:title, :raw, :author, :published]
  end
end
