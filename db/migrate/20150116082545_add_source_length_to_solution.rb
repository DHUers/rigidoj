class AddSourceLengthToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :source_length, :integer, default: 0
  end
end
