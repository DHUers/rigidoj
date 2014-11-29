class UserPolicy < ApplicationPolicy
  def create?
    true
  end

  def permitted_attributes
    [:username, :name, :email, :password, :password_confirmation]
  end
end
