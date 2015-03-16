class AddCommentNumberCountToPost < ActiveRecord::Migration
  def change
    add_column :posts, :comment_count, :integer, default: 0, null: false
  end
end
