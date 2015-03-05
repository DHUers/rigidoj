class AddDetailedReportToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :detailed_report, :text
  end
end
