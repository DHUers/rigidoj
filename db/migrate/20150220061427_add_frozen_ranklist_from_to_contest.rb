class AddFrozenRanklistFromToContest < ActiveRecord::Migration
  def change
    add_column :contests, :frozen_ranklist_from, :datetime
  end
end
