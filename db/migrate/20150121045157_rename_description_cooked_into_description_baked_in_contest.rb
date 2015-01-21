class RenameDescriptionCookedIntoDescriptionBakedInContest < ActiveRecord::Migration
  def change
    rename_column :contests, :description_cooked, :description_baked
  end
end
