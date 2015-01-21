class CreateIndexToContestProblems < ActiveRecord::Migration
  def change
    add_index :contest_problems, [:contest_id, :problem_id], unique: true
  end
end
