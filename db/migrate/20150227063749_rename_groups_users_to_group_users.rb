class RenameGroupsUsersToGroupUsers < ActiveRecord::Migration
  def change
    rename_table :groups_users, :group_users
  end
end
