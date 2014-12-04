class UpdateProblem < ActiveRecord::Migration
  def change
    change_column_null :problems, :title, false
    remove_column :problems, :excerpt
    change_column_null :problems, :raw, false
    change_column_null :problems, :published, false
    add_column :problems, :input_file_id, :integer
    add_column :problems, :output_file_id, :integer
    add_column :problems, :jugde_type, :integer, null: false, default: 0
  end
end
