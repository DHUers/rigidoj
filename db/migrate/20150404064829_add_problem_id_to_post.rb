class AddProblemIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :problem_id, :integer
  end
end
