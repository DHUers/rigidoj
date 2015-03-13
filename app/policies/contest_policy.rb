class ContestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user && user.staff?
  end

  def show?
    if public_contest?
      true
    else
      user && (user.admin? || in_group?)
    end
  end

  def show_details?
    show? && (record.started? || supervise?)
  end

  def update?
    supervise?
  end

  def create_solution?
    user && show_details? && (record.ongoing? || user.admin? || in_judger_group?)
  end

  def rejudge_solution?
    user && (user.admin? || in_judger_group?)
  end

  def rejudge_all_solution?
    user && (user.admin? || (in_judger_group? && user.moderator?))
  end

  alias_method :send_notification?, :rejudge_all_solution?

  def destroy?
    user && user.admin?
  end

  private

  def public_contest?
    @public_contest ||= record.groups.empty?
  end

  def in_judger_group?
    @in_judger_group ||= user && user.groups.include?(record.judger_group)
  end

  def in_visible_to_group?
    @in_visible_to_group ||= user && record.groups.any? { |g| user.groups.include?(g) }
  end

  def in_group?
    @in_group ||= in_judger_group? || in_visible_to_group?
  end

  def supervise?
    @supervise ||= user && (user.admin? || (in_judger_group? && user.moderator?))
  end

end
