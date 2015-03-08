class RenameProblemFields < ActiveRecord::Migration
  def change
    rename_column :problems, :input_file, :input_file_id
    rename_column :problems, :output_file, :output_file_id
    rename_column :problems, :judger_program, :judger_program_id
    remove_column :problems, :input_file_uuid, :string
    remove_column :problems, :output_file_uuid, :string
  end
end
