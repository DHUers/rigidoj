class DropUselessColumnInUserStat < ActiveRecord::Migration
  def change
    remove_column :user_stats, :problems_created
    remove_column :user_stats, :problems_entered
    remove_column :user_stats, :time_read
    remove_column :user_stats, :days_visited
    remove_column :user_stats, :contests_created
  end
end
