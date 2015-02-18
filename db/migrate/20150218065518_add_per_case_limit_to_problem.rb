class AddPerCaseLimitToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :per_case_limit, :boolean, default: false, null: false
  end
end
