class CommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    user && user.admin?
  end

end
