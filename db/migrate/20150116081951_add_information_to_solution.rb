class AddInformationToSolution < ActiveRecord::Migration
  def change
    remove_column :solutions, :solution_status
    add_column :solutions, :solution_status, :string, default: '', null: false
    add_column :solutions, :draft, :boolean, default: false, null: false
  end
end
