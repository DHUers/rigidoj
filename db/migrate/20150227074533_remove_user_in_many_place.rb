class RemoveUserInManyPlace < ActiveRecord::Migration
  def change
    remove_column :contests, :user_id
    remove_column :problems, :user_id
  end
end
