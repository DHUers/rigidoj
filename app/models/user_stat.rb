class UserStat < ActiveRecord::Base
  belongs_to :user

  def submitted?
    first_solution_created_at != nil
  end

  def set_first_solution!(time)

  end
end

# == Schema Information
#
# Table name: user_stats
#
#  user_id                   :integer          not null, primary key
#  contests_joined           :integer          default(0), not null
#  solutions_created         :integer          default(0), not null
#  first_solution_created_at :datetime
#  problems_solved           :integer          default(0), not null
#
