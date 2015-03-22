class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where(published: true)
      end
    end
  end

  def create?
    user
  end

  def show?
    record.published? || (user && user.admin?)
  end

  def show_with_contest?
    user && (user.id == record.comments.first.user_id || user.admin? || record.contest.in_judger_group?)
  end

  def update?
    user && (user.admin? || record.user.id == user.id)
  end

  def destroy?
    user && user.admin?
  end

  def permitted_attributes
    [:title, :raw, :author, :published]
  end
end
