class PostPolicy < ApplicationPolicy
  def create?
    @user
  end

  def update?
    post.published?
  end

  def permitted_attributes
    [:title, :raw, :author]
  end
end
