class NukeDraft < ActiveRecord::Migration
  def change
    remove_column :problems, :draft
    remove_column :solutions, :draft
  end
end
