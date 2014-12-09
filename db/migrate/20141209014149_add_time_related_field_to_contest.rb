class AddTimeRelatedFieldToContest < ActiveRecord::Migration
  def change
    add_column :contests, :started_at, :datetime, null: false
    add_column :contests, :end_at, :datetime, null: false
    add_column :contests, :delayed_till, :datetime
    add_column :contests, :contest_type, :integer, default: 0, null: false
  end
end
