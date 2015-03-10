class UserProblemStat < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user

  enum state: [:null, :tried, :accepted]

  def already_accepted?
    stat.state == 'accepted'
  end

  def mark_accepted_solution_time!(solution_created_at)
    update_attributes!(state: :accepted, first_accepted_at: solution_created_at)
  end

  def keep_track_latest_solution_time!(solution_created_at)
    if last_submitted_at.nil? || last_submitted_at < solution_created_at
      update_attribute(:last_submitted_at, solution_created_at)
    end
  end
end

# == Schema Information
#
# Table name: user_problem_stats
#
#  problem_id        :integer          not null
#  user_id           :integer          not null
#  last_submitted_at :datetime
#  state             :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  first_accepted_at :datetime
#  id                :integer          not null, primary key
#
# Indexes
#
#  index_user_problem_stats_on_user_id_and_problem_id  (user_id,problem_id) UNIQUE
#
