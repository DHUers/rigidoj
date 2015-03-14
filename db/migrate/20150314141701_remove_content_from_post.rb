class RemoveContentFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :user_id
    remove_column :posts, :raw
    remove_column :posts, :baked
  end
end
