class AddPostIdToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :post_id, :integer
  end
end
