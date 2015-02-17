class ChangeProblemLimitType < ActiveRecord::Migration
  def up
    remove_column :problems, :memory_limit
    remove_column :problems, :time_limit
    add_column :problems, :memory_limit, :integer, default: '{"default":65535}'
    add_column :problems, :time_limit, :integer, default: '{"default":1000}'
  end

  def down
    remove_column :problems, :memory_limit
    remove_column :problems, :time_limit
    add_column :problems, :memory_limit, :integer, default: 65535
    add_column :problems, :time_limit, :integer, default: 1000
  end
end
