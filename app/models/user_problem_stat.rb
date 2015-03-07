class UserProblemStat < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user
  belongs_to :solution

  enum state: [:viewed, :tried, :accepted]

  validate :ensure_newer_solution

  def ensure_newer_solution
    if last_submitted_at && solution &&
        last_submitted_at > solution.created_at
      errors.add(:last_submitted_at, :invalid, options)
    end
  end

  def already_accepted?
    stat.state == 'accepted'
  end

  def mark_accepted_solution!(created_time)
    update_attributes!(state: :accepted, first_accepted_at: created_time)
  end

  def keep_track_latest_solution!(created_time)
    update_attribute(:last_submitted_at, created_time) if last_submitted_at < created_time
  end
end

# == Schema Information
#
# Table name: user_problem_stats
#
#  problem_id        :integer          not null
#  user_id           :integer          not null
#  last_submitted_at :datetime
#  state             :integer          default("0")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  first_accepted_at :datetime
#
# Indexes
#
#  index_user_problem_stats_on_user_id_and_problem_id  (user_id,problem_id) UNIQUE
#
