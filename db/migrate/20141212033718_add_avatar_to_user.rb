class AddAvatarToUser < ActiveRecord::Migration
  def change
    remove_column :users, :uploaded_avatar_id, :string
    add_column :users, :avatar, :string
    add_column :users, :avatar_digest, :string
    add_column :users, :show_email, :boolean, default: true, null: false
    add_index :users, :avatar_digest, unique: true
    add_column :user_stats, :problems_solved, :string, default: 0, null: false
    rename_column :user_stats, :users_id, :user_id
    rename_column :user_profiles, :users_id, :user_id
  end
end
