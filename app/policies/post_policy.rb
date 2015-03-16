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
    user
  end

  def show?
    record.published? || user.admin?
  end

  def update?
    create?
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    [:title, :raw, :author, :published]
  end
end
