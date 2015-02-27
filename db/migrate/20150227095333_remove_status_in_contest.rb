class RemoveStatusInContest < ActiveRecord::Migration
  def change
    remove_column :contests, :status
  end
end
