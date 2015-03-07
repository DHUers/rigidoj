class AddIdToUserProblemStat < ActiveRecord::Migration
  def change
    add_column :user_problem_stats, :id, :primary_key
  end
end
