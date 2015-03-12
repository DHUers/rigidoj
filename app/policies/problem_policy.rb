class ProblemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where('visible = ? OR visible_to_group in (?)', true, user ? user.group_ids : [])
      end
    end
  end

  def create?
    user && user.staff?
  end

  alias_method :import?, :create?

  def show?
    record.visible || if user
                        user.admin? || record.visible_to_group? && record.visible_to_group.users.include?(user)
                      else
                        false
                      end
  end

  alias_method :excerpt?, :show?

  def update?
    create? && show?
  end

  def destroy?
    user && user.admin?
  end

  def permitted_attributes
    %i(title
       raw
       source
       default_time_limit
       default_memory_limit
       judge_type
       judger_program_platform
       remote_proxy_vendor
       public
       input_file
       output_file
       judger_program
       additional_limits)
  end
end
