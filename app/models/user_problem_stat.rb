class UserProblemStat < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user

  enum state: [:null, :tried, :accepted]

  def already_accepted?
    state == 'accepted'
  end

  def mark_accepted_solution_time!(solution_created_at)
    update_attributes!(state: :accepted, first_accepted_at: solution_created_at)
  end

  def keep_track_latest_solution_time!(solution_created_at)
    if last_submitted_at.nil? || last_submitted_at < solution_created_at
      self.last_submitted_at = solution_created_at
      save!
    end
    if user.user_stat.first_solution_created_at.nil?
      user.user_stat.set_first_solution!(solution_created_at)
    end
  end

  def latest_submission_time
    time = already_accepted? ? first_accepted_at : last_submitted_at

    time ? time.to_formatted_s(:long_add_second) : nil
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
