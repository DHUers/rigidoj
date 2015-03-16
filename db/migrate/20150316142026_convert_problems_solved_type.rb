class ConvertProblemsSolvedType < ActiveRecord::Migration
  def change
    remove_column :user_stats, :problems_solved
    add_column :user_stats, :problems_solved, :integer, default: 0, null: false
  end
end
