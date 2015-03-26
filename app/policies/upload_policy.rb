class UploadPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user && user.staff?
        scope.all
      else
        []
      end
    end
  end

  def index?
    user && user.staff?
  end

  def create?
    user && user.staff?
  end
end
