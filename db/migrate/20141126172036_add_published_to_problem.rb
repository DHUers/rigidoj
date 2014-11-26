class AddPublishedToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :published, :boolean
  end
end
