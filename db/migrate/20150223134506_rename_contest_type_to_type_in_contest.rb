class RenameContestTypeToTypeInContest < ActiveRecord::Migration
  def change
    rename_column :contests, :contest_type, :type
  end
end
