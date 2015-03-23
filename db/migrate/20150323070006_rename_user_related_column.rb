class RenameUserRelatedColumn < ActiveRecord::Migration
  def change
    rename_column :users, :remember_hash, :auth_token
  end
end
