class AddUniqIndexToContestsJoinTable < ActiveRecord::Migration
  def change
    add_index :contest_users, [:contest_id, :user_id], unique: true
  end
end
