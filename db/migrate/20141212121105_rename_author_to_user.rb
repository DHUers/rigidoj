class RenameAuthorToUser < ActiveRecord::Migration
  def change
    rename_column :problems, :author_id, :user_id
    rename_column :contests, :author_id, :user_id
    rename_column :posts, :author_id, :user_id
  end
end
