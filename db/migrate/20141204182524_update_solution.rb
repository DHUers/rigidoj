class UpdateSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :type, :string
    rename_column :solutions, :language, :platform
    change_column_null :solutions, :platform, false
    add_column :solutions, :report, :text, default: ''
    rename_column :solutions, :result, :solution_status
  end
end
