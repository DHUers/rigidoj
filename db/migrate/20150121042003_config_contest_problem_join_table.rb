class ConfigContestProblemJoinTable < ActiveRecord::Migration
  def change
    rename_table :contests_problems, :contest_problems
    add_column :contest_problems, :position, :integer
  end
end
