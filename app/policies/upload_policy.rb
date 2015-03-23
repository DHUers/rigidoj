class UploadPolicy < ApplicationPolicy
  def create?
    user && user.admin?
  end
end
