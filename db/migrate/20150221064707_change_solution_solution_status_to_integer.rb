class ChangeSolutionSolutionStatusToInteger < ActiveRecord::Migration
  def change
    remove_column :solutions, :solution_status
    add_column :solutions, :solution_status, :integer, null: false, default: 0
  end
end
