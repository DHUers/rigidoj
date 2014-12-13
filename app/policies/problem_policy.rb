class ProblemPolicy < ApplicationPolicy
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

  def permitted_attributes
    [:title, :raw, :author, :published]
  end
end
