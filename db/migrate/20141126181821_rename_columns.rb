class RenameColumns < ActiveRecord::Migration
  def change
    rename_column :problems, :author, :author_id
    rename_column :posts, :author, :author_id
  end
end
