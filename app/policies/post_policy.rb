class PostPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    post.published?
  end

  def permitted_attributes
    [:title, :raw, :author, :published]
  end
end
