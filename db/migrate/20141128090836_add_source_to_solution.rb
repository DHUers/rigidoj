class AddSourceToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :source, :text, default: ''
  end
end
