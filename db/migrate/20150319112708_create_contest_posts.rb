class CreateContestPosts < ActiveRecord::Migration
  def change
    add_column :posts, :contest_id, :integer
  end
end
