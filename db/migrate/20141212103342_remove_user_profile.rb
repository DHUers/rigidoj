class RemoveUserProfile < ActiveRecord::Migration
  def change
    drop_table :user_profiles
    add_column :users, :website, :string, limit: 255
    remove_column :users, :locale
  end
end
