class AddGroupNameToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :group_name, :string
  end
end
