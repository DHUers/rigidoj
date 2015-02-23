class StiForSolutionAndContest < ActiveRecord::Migration
  def change
    remove_column :solutions, :source_length, :integer
    rename_column :solutions, :solution_status, :status

    rename_column :contests, :contest_status, :status
    remove_column :contests, :contest_type, :integer
    add_column :contests, :contest_type, :string
    rename_column :contests, :frozen_ranklist_from, :frozen_ranking_from

    remove_column :problems, :judger_program_uuid, :string
    change_column :problems, :judge_type, :integer, default: 0, null: false
  end
end
