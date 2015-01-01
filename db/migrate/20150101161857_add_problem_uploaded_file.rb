class AddProblemUploadedFile < ActiveRecord::Migration
  def change
    add_column :problems, :input_file_uuid, :string
    add_column :problems, :output_file_uuid, :string
    add_column :problems, :judger_program_uuid, :string
  end
end
