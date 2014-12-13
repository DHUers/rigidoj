class ChangeProblemRelatedFile < ActiveRecord::Migration
  def change
    remove_column :problems, :input_file_id
    remove_column :problems, :output_file_id
    remove_column :problems, :uploaded_program_id
    remove_column :problems, :uploaded_program_platform
    add_column :problems, :slug, :string, default: ''
    add_column :problems, :judger_program_platform, :integer
    add_column :problems, :input_file, :string
    add_column :problems, :output_file, :string
    add_column :problems, :judger_program, :string
    add_column :problems, :remote_proxy_vendor, :string, default: ''
  end
end
