class AddDefaultPlatformToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_platform, :string, default: '', null: false
  end
end
