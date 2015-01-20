class ProblemPolicy < ApplicationPolicy
  def create?
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    user && user.staff?
  end

  def import?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
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
