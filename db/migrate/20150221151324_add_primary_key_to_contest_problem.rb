class AddPrimaryKeyToContestProblem < ActiveRecord::Migration
  def change
    add_column :contest_problems, :id, :primary_key, null: false

  end
end
