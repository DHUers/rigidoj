class RenamePublicToVisibleInProblem < ActiveRecord::Migration
  def change
    rename_column :problems, :public, :visible
  end
end
