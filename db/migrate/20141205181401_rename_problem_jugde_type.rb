class RenameProblemJugdeType < ActiveRecord::Migration
  def change
    rename_column :problems, :jugde_type, :judge_type
    add_column :problems, :uploaded_program_id, :integer
    add_column :problems, :uploaded_program_platform, :string
  end
end
