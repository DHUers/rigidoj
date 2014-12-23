class ChangeProblemJudgerProgramPlatformType < ActiveRecord::Migration
  def change
    change_column :problems, :judger_program_platform, :string, default: ''
    change_column_default :problems, :input_file, ''
    change_column_default :problems, :output_file, ''
    change_column_default :problems, :judger_program, ''
  end
end
