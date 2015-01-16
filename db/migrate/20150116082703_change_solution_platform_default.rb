class ChangeSolutionPlatformDefault < ActiveRecord::Migration
  def change
    change_column_default :solutions, :platform, ''
  end
end
