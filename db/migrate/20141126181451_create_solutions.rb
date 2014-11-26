class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :user_id, null: false
      t.integer :problem_id
      t.integer :contest_id
      t.integer :result, default: 0
      t.integer :memory_usage, default: 0
      t.integer :time_usage, default: 0
      t.string :language, default: 0
      t.integer :revision, default: 0

      t.timestamps null: false
    end
  end
end
