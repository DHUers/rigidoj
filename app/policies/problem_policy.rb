class PostPolicy < ApplicationPolicy
  def create?
    @user
  end

  def update?
    problem.published?
  end

  def permitted_attributes
    [:title, :raw, :author, :published]
  end
end
