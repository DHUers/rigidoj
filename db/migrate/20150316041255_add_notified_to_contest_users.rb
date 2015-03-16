class AddNotifiedToContestUsers < ActiveRecord::Migration
  def change
    add_column :contests, :started_notified, :boolean, default: false, null: false
    add_column :contests, :delayed_notified, :boolean, default: false, null: false
  end
end
