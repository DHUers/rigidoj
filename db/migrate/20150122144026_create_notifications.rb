class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notification_type, null: false
      t.integer :user_id, null: false
      t.string :data, null: false
      t.boolean :read, default: false, null: false
      t.integer :problem_id
      t.integer :solution_id
      t.integer :contest_id

      t.timestamps null: false
    end
  end
end
