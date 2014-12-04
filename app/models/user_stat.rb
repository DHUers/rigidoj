class UserStat < ActiveRecord::Base

end

# == Schema Information
#
# Table name: user_stats
#
#  users_id                  :integer          not null, primary key
#  problems_entered          :integer          default("0"), not null
#  problems_created          :integer          default("0"), not null
#  time_read                 :integer          default("0"), not null
#  days_visited              :integer          default("0"), not null
#  contests_created          :integer          default("0"), not null
#  contests_joined           :integer          default("0"), not null
#  solutions_created         :integer          default("0"), not null
#  solutions_solved          :integer          default("0"), not null
#  first_solution_created_at :datetime
#
