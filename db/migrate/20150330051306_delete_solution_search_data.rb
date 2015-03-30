class DeleteSolutionSearchData < ActiveRecord::Migration
  def change
    drop_table :solution_search_data
  end
end
