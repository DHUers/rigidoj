class ProblemPolicy < ApplicationPolicy
  def create?
    @user
  end

  def update?
    @record.published?
  end

  def permitted_attributes
    [:title, :raw, :author, :published]
  end
end
