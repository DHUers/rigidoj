class AddRememberHashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_hash, :string, limit: 60
    add_column :users, :username_lower, :string, null: false, limit: 60

    add_index :users, :username_lower, unique: true
  end
end
