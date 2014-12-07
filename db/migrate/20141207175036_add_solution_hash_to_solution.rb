class AddSolutionHashToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :solution_hash, :string

    add_index :solutions, :solution_hash
  end
end
