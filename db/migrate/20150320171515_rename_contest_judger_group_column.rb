class RenameContestJudgerGroupColumn < ActiveRecord::Migration
  def change
    rename_column :contests, :judger_group, :judger_group_id
  end
end
