class RemoveHashInSolution < ActiveRecord::Migration
  def change
    remove_column :solutions, :solution_hash
  end
end
