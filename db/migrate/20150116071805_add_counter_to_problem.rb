class AddCounterToProblem < ActiveRecord::Migration
  def change
    remove_column :problems, :source
    add_column :problems, :submission_count, :integer, default: 0, null: false
    add_column :problems, :accepted_count, :integer, default: 0, null: false
  end
end
