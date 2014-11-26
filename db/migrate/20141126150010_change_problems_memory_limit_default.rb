class ChangeProblemsMemoryLimitDefault < ActiveRecord::Migration
  def change
    change_column :problems, :memory_limit, :integer, default: 65535
  end
end
