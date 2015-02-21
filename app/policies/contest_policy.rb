class ContestPolicy < ApplicationPolicy
  def create?
    true
  end

  def permitted_attributes
    %i(title
       description_raw
       started_at
       end_at
       delayed_till
       frozen_ranklist_from
       contest_status)
  end
end
