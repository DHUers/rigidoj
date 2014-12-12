class AddVisibileAttrToProblem < ActiveRecord::Migration
  def change
    rename_column :problems, :published, :public
    change_column_default :problems, :public, false
    add_column :problems, :draft, :boolean, default: false, null: false
  end
end
