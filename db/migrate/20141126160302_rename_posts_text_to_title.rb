class RenamePostsTextToTitle < ActiveRecord::Migration
  def change
    rename_column :posts, :text, :title
  end
end
