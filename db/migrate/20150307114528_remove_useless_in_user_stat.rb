class RemoveUselessInUserStat < ActiveRecord::Migration
  def change
    remove_column :user_stats, :solutions_solved
  end
end
