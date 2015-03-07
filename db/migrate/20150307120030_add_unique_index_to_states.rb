class AddUniqueIndexToStates < ActiveRecord::Migration
  def change
    remove_column :user_problem_stats, :solution_id
    add_index :user_problem_stats, [:user_id, :problem_id], unique: true
  end
end
