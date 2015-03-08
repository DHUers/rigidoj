class UserPolicy < ApplicationPolicy
  def create?
    true
  end

  def show?
    true
  end

  def update_profile?
    update?
  end

  def update?
    user.id == record.id || user.staff?
  end

  def permitted_attributes
    [:username, :name, :email, :password, :password_confirmation]
  end
end
