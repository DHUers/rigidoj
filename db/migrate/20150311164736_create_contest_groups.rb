class CreateContestGroups < ActiveRecord::Migration
  def change
    create_table :contest_groups do |t|
      t.integer :contest_id, null: false
      t.integer :group_id, null: false
    end

    add_index :contest_groups, [:contest_id, :group_id], unique: true
  end
end
