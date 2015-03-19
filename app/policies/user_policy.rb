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
    user && (user.id == record.id || admin?)
  end

  def search?
    admin?
  end

  def admin?
    user && user.admin?
  end

  def permitted_attributes
    [:username, :name, :email, :password, :password_confirmation]
  end
end
