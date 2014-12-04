class UpdateContest < ActiveRecord::Migration
  def change
    rename_column :contests, :description, :description_raw
    change_column :contests, :description_raw, :text, default: ''
    add_column :contests, :description_cooked, :text, default: ''
    remove_column :contests, :published
    add_column :contests, :contest_status, :integer, null: false, default: 0
  end
end
