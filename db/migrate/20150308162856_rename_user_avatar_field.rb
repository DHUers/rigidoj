class RenameUserAvatarField < ActiveRecord::Migration
  def change
    rename_column :users, :avatar, :avatar_id
    remove_column :users, :avatar_uuid
    rename_column :users, :avatar_original_filename, :avatar_filename
  end
end
