class ChangeDefaultPositionInContestProblems < ActiveRecord::Migration
  def change
    change_column_default :contest_problems, :position, 0
    change_column_null :contest_problems, :position, false
  end
end
