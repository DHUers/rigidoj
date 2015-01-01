class RenameUserAvatarDigest < ActiveRecord::Migration
  def change
    rename_column :users, :avatar_digest, :avatar_original_filename
    add_column :users, :avatar_uuid, :string
  end
end
