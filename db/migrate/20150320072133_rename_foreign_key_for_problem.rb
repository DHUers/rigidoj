class RenameForeignKeyForProblem < ActiveRecord::Migration
  def change
    rename_column :problems, :visible_to_group, :visible_to_group_id
  end
end
