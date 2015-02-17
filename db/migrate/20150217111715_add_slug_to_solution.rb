class AddSlugToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :slug, :string
  end
end
