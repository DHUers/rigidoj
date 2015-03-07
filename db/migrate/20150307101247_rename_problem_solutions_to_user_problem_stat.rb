class RenameProblemSolutionsToUserProblemStat < ActiveRecord::Migration
  def change
    rename_table :problem_solutions, :user_problem_stats
  end
end
