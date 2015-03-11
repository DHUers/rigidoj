class AddGroupConstraints < ActiveRecord::Migration
  def change
    add_column :problems, :visible_to_group, :integer
    add_column :contests, :judger_group, :integer
  end
end
